class AddProfileFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :cloudinary_url, :string
    add_column :users, :cloudinary_public_id, :string
    add_column :users, :address, :string
    add_column :users, :latitude, :decimal
    add_column :users, :longitude, :decimal
  end
end
