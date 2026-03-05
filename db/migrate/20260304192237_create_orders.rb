class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.jsonb :items, null: false, default: []
      t.decimal :total, precision: 10, scale: 2, null: false
      t.integer :status, default: 0, null: false
      t.text :shipping_address, null: false
      t.string :payment_method, null: false, default: 'COD'
      t.string :payment_status, null: false, default: 'Pending'

      t.timestamps
    end
  end
end
