class Review < ApplicationRecord
  belongs_to :reservation
  has_one :answer

  validates :score, presence: true, inclusion: { in: 1..5 }
  validates :description, presence:true
end