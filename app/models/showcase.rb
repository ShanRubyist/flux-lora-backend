class Showcase < ApplicationRecord
  belongs_to :lora
  has_one_attached :image
end
