class PlansController < ApplicationController
  skip_before_action :authorize_request, only: [:index]

  def index
    plans = Plan.all.order(:price)
    render json: plans
  end
end
