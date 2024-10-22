class AddTToLoras < ActiveRecord::Migration[7.0]
  def change
    add_column :loras, :t, :string, default: 'lora'
  end
end
