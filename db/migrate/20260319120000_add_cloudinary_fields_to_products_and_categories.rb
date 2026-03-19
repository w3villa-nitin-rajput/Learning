class AddCloudinaryFieldsToProductsAndCategories < ActiveRecord::Migration[8.1]
  def change
    # Add Cloudinary fields to products table
    add_column :products, :cloudinary_url, :string
    add_column :products, :cloudinary_public_id, :string

    # Add Cloudinary fields to categories table
    add_column :categories, :cloudinary_url, :string
    add_column :categories, :cloudinary_public_id, :string

    # Add indexes for public IDs for faster lookups during deletion
    add_index :products, :cloudinary_public_id
    add_index :categories, :cloudinary_public_id
  end
end
