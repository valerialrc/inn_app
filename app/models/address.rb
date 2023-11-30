class Address < ApplicationRecord
  belongs_to :inn
  validates :street, :number, :district, :city, :state, :cep, presence: true

  validates_uniqueness_of :inn_id

  validate :create_city

  private

  def create_city
    unless City.exists?(name: city)
      City.create!(name: city)
    end
  end
end