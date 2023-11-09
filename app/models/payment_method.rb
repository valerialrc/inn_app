class PaymentMethod < ApplicationRecord
  has_many :inns
  validates :name, presence: true
  accepts_nested_attributes_for :inns
end
