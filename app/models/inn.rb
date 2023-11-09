class Inn < ApplicationRecord
  has_one :address, inverse_of: :inn
  belongs_to :user
  belongs_to :payment_method
  validates :user_id, :trade_name, :legal_name, :cnpj, :phone, :email, :description,
            :payment_method_id, :checkin_time,
            :checkout_time, :policies, presence: true   
  
  accepts_nested_attributes_for :address

end
