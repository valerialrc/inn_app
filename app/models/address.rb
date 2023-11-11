class Address < ApplicationRecord
  belongs_to :inn
  validates :street, :number, :district, :city, :state, :cep, presence: true

  validates_uniqueness_of :inn_id
end