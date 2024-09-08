class CreateLoras < ActiveRecord::Migration[7.0]
  def change
    create_table :loras, id: :uuid do |t|
      t.string :name, null: false
      t.string :value, null: false
      t.integer :cost_credits, null: false
      t.timestamps
    end
  end
end