class Reservation < ApplicationRecord
  belongs_to :room
  belongs_to :customer, optional: true
  has_one :active_reservation
  has_one :review

  before_validation :calculate_total_price, on: :create
  before_validation :generate_code, on: :create

  validates :checkin_date, :checkout_date, :guests_number, :status, :code, presence: true

  after_save :confirm_status
  validate :checkin_date_is_future, on: :create
  validate :checkout_date_is_future, on: :create
  validate :checkout_date_is_after_checkin_date
  validate :no_date_overlap, on: :create
  validate :max_occupancy
  enum status: { pending: 0, confirmed: 5, active: 6, closed: 7, canceled: 9 }

  private

  def confirm_status
    if self.pending?
      self.confirmed!
    end
  end

  def checkin_date_is_future
    if self.checkin_date.present? && self.checkin_date <= Date.today
      self.errors.add(:checkin_date, 'deve ser futura.')
    end
  end

  def checkout_date_is_future
    if self.checkout_date.present? && self.checkout_date <= Date.today
      self.errors.add(:checkout_date, 'deve ser futura.')
    end
  end

  def checkout_date_is_after_checkin_date
    if self.checkout_date.present? && self.checkout_date <= checkin_date
      self.errors.add(:checkout_date, 'deve ser após a Data de Check-in.')
    end
  end 

  def calculate_total_price
    if room && self.total_price == 0 && self.checkin_date && self.checkout_date
      (self.checkin_date..self.checkout_date.prev_day).each do |date|
        self.total_price += room.price_on_reservation_date(date)
      end
    end
  end

  def no_date_overlap
    if Reservation.exists?(['room_id = ? AND ((checkin_date <= ? AND checkout_date >= ?) OR (checkin_date <= ? AND checkout_date >= ?)) AND status != ?',
                            room_id, checkout_date, checkin_date, checkout_date, checkin_date, Reservation.statuses[:canceled]])
      errors.add(:base, 'Já existe uma reserva para este quarto durante este período.')
    end
  end

  def max_occupancy
    if room && guests_number && room.max_occupancy < self.guests_number 
      errors.add(:base, 'O Número de Hóspedes é maior que a capacidade do quarto.')
    end
  end

  def generate_code
    self.code = SecureRandom.alphanumeric(8).upcase
  end
end
