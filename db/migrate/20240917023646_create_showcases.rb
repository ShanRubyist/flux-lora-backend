class CreateShowcases < ActiveRecord::Migration[7.0]
  def change
    create_table :showcases, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.uuid :lora_id, null: false
      t.text :prompt, null: false
      t.string "predict_id"
      t.integer "seed"
      t.integer "num_outputs"
      t.string "aspect_ratio"
      t.string "output_format"
      t.integer "output_quality"
      t.boolean "disable_safety_checker"
      t.string "output"
      t.jsonb "data"
      t.integer "cost_credits"
      t.string "model"
      t.timestamps
    end
  end
end


