class Inn < ApplicationRecord
  has_one :address, inverse_of: :inn
  has_many :rooms, dependent: :restrict_with_error
  has_many :reservations, through: :rooms
  has_many :active_reservations, through: :reservations
  belongs_to :user
  belongs_to :payment_method

  accepts_nested_attributes_for :address

  validates :user_id, :trade_name, :legal_name, :cnpj, :phone, :email, :description,
            :payment_method_id, :checkin_time,
            :checkout_time, :policies, presence: true   
  
  validates_uniqueness_of :user_id
end