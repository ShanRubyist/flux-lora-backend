class AddRunsToLoras < ActiveRecord::Migration[7.0]
  def change
    add_column :loras, :runs, :integer
  end
end
