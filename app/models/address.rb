class Address < ApplicationRecord
  belongs_to :inn
  validates :street, :number, :district, :city, :state, :cep, presence: true
end
