class AddExamplePicToLoras < ActiveRecord::Migration[7.0]
  def change
    add_column :loras, :example_pics, :json
    add_index :loras, [:value], name: "index_loras_on_value", unique: true
  end
end
