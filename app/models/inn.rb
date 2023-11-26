class Inn < ApplicationRecord
  has_one :address, inverse_of: :inn
  has_many :rooms, dependent: :restrict_with_error
  has_many :reservations, through: :rooms
  belongs_to :user
  belongs_to :payment_method
  has_many :reviews, through: :rooms

  accepts_nested_attributes_for :address

  validates :user_id, :trade_name, :legal_name, :cnpj, :phone, :email, :description,
            :payment_method_id, :checkin_time,
            :checkout_time, :policies, presence: true   
  
  validates_uniqueness_of :user_id

  def average_rating
    reviews.average(:score)
  end
end