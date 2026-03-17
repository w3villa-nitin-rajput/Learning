require 'stripe'

class SubscriptionsController < ApplicationController
  skip_before_action :authorize_request, only: [:webhook]
  
  # POST /subscribe
  def create
    plan_id = params[:plan]
    plan = Plan.find_by(id: plan_id)
    puts "#{plan}"

    if @current_user.plan_expires_at&.future?
      return render json: { error: "You already have a plan" }, status: :unprocessable_entity
    end
    unless plan
      return render json: { error: "Invalid plan" }, status: :unprocessable_entity
    end

    begin
      session = Stripe::Checkout::Session.create({
        payment_method_types: ['card'],
        line_items: [{
          price_data: {
            currency: 'inr',
            product_data: {
            name: plan.name,
            },
            unit_amount: (plan.price * 100).to_i,
          },
          quantity: 1,
        }],
        mode: 'payment',
        success_url: "#{ENV['FRONTEND_URL']}/payment-success?session_id={CHECKOUT_SESSION_ID}",
        cancel_url: "#{ENV['FRONTEND_URL']}/pricing",
        customer_email: @current_user.email,
        metadata: {
          user_id: @current_user.id,
          plan: plan_id
        }
      })

      render json: { checkout_url: session.url }, status: :ok
    rescue Stripe::StripeError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  # POST /subscriptions/webhook
  def webhook
    puts "Webhook hit!"

    # Rewind is critical — Rails middleware may have already read the body once.
    # Without rewind, payload will be an empty string and signature verification fails.
    request.body.rewind
    payload = request.body.read

    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = ENV['STRIPE_WEBHOOK_SECRET']

    puts "Payload length: #{payload.length}"
    puts "Stripe-Signature header present: #{sig_header.present?}"
    puts "Webhook secret present: #{endpoint_secret.present?}"

    if payload.blank?
      puts "ERROR: Empty payload — body was not rewound or never sent"
      return head :bad_request
    end

    unless sig_header.present?
      puts "ERROR: Missing Stripe-Signature header — is Stripe CLI forwarding active?"
      return head :bad_request
    end

    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      puts "JSON parse error: #{e.message}"
      return head :bad_request
    rescue Stripe::SignatureVerificationError => e
      puts "Signature verification failed: #{e.message}"
      puts "  - Make sure STRIPE_WEBHOOK_SECRET matches what 'stripe listen' printed"
      return head :bad_request
    end

    puts "Webhook event received: #{event.type}"

    # Handle the event
    case event.type
    when 'checkout.session.completed'
      session = event.data.object
      handle_checkout_completed(session)
    end

    head :ok
  end

  private

  def handle_checkout_completed(session)
  # Use session.metadata['type'] instead of session.metadata.type
  # session.metadata returns a StripeObject which acts like a Hash
    type = session.metadata['type'] 
    user_id = session.metadata['user_id']
    
    user = User.find_by(id: user_id)
    return unless user

    if type == 'product_purchase'
      handle_product_purchase(session, user)
    else
      # Defaulting to subscription for now
      handle_subscription(session, user)
    end
  end

  def handle_subscription(session, user)
    plan_id = session.metadata.plan
    plan = Plan.find_by(id: plan_id)
    return unless plan
    
    user.transaction do
      user.update!(
        plan: plan.plan_type,
        plan_id: plan.id,
        plan_expires_at: [user.plan_expires_at, Time.current].compact.max + plan.duration_hours.hours
      )
    end
  end

  def handle_product_purchase(session, user)
    shipping_address = session.metadata.shipping_address
    
    user.transaction do
      # 1. Create the Order
      items = user.cart_items.includes(:product).map do |item|
        {
          product_id: item.product_id,
          name: item.product.name,
          quantity: item.quantity,
          price: item.product.price_for_user(user).to_f,
          image: item.product.image_urls&.first
        }
      end

      total = items.sum { |i| i[:price] * i[:quantity] }

      user.orders.create!(
        items: items,
        total: total,
        shipping_address: shipping_address || user.address || "No address provided",
        payment_method: "Stripe",
        payment_status: "Paid",
        status: :confirmed
      )

      # 2. Clear Cart
      user.cart_items.destroy_all
    end
  end
end
