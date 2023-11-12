class Room < ApplicationRecord
  belongs_to :inn
  has_many :period_prices, dependent: :destroy

  validates :name, :description, :dimension, :max_occupancy, :daily_rate, :inn_id, presence: true

  validates_inclusion_of :has_bathroom, :has_balcony, :has_air_conditioning, :has_tv,
                         :has_wardrobe, :has_safe, :is_accessible, :is_available, in: [true, false]

  def current_price
    period_prices.find_by('? BETWEEN start_date AND end_date', Date.today)&.daily_value || default_price
  end

  def default_price
    daily_rate
  end
end 
