class CreatePlans < ActiveRecord::Migration[8.1]
  def change
    create_table :plans do |t|
      t.string :name
      t.decimal :price, precision: 10, scale: 2
      t.integer :duration_hours
      t.string :plan_type
      t.string :stripe_price_id
      t.text :description
      t.string :benefit
      t.string :color
      t.string :text_color
      t.string :border_color
      t.boolean :popular

      t.timestamps
    end
  end
end
