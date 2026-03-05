class CreateCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :path
      t.string :image_url
      t.string :bg_color

      t.timestamps
    end
  end
end
