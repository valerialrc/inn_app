class Room < ApplicationRecord
  belongs_to :inn

  validates :name, :description, :dimension, :max_occupancy, :daily_rate, :inn_id, presence: true

  validates_inclusion_of :has_bathroom, :has_balcony, :has_air_conditioning, :has_tv,
                         :has_wardrobe, :has_safe, :is_accessible, :is_available, in: [true, false]
end 
