class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :category, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.decimal :offer_price, precision: 10, scale: 2
      t.string :image_urls, array: true, default: []
      t.string :description, array: true, default: []
      t.boolean :in_stock, default: true

      t.timestamps
    end

    add_index :products, :category
  end
end
