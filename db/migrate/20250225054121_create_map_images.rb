class CreateMapImages < ActiveRecord::Migration[8.0]
  def change
    create_table :map_images do |t|
      t.string :name
      t.string :file
      t.text :remarks

      t.timestamps null: false
    end
    add_index :map_images, :name, unique: true
  end
end
