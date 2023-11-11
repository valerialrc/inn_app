class Inn < ApplicationRecord
  has_one :address, inverse_of: :inn
  has_many :rooms, dependent: :restrict_with_error
  belongs_to :user
  belongs_to :payment_method

  accepts_nested_attributes_for :address

  validates :user_id, :trade_name, :legal_name, :cnpj, :phone, :email, :description,
            :payment_method_id, :checkin_time,
            :checkout_time, :policies, presence: true   
  
  validates_uniqueness_of :user_id
end