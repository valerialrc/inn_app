class Room < ApplicationRecord
  belongs_to :inn
  has_many :period_prices, dependent: :destroy
  has_many :reservations, dependent: :destroy
  has_many :active_reservations, through: :reservations
  has_many :reviews, through: :reservations


  validates :name, :description, :dimension, :max_occupancy, :daily_rate, :inn_id, presence: true

  validates_inclusion_of :has_bathroom, :has_balcony, :has_air_conditioning, :has_tv,
                         :has_wardrobe, :has_safe, :is_accessible, :is_available, in: [true, false]

  def current_price
    p = period_prices.find_by('? BETWEEN start_date AND end_date', Date.today)&.daily_value || default_price
  end

  def price_on_reservation_date(reservation_date)
    specific_period_price = period_prices.find_by('? BETWEEN start_date AND end_date', reservation_date)
    specific_period_price&.daily_value || default_price
  end

  def default_price
    daily_rate
  end

  def available_for_reservation?(reservation)
    return [false, 'Quarto não disponível para reserva.'] unless self.is_available?
    return reservation.valid?
  end
end 
