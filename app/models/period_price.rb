class PeriodPrice < ApplicationRecord
  belongs_to :room

  validates :start_date, :end_date, :daily_value, presence: true
  validate :no_date_overlap

  private

  def no_date_overlap
    if PeriodPrice.exists?(['room_id = ? AND ((start_date <= ? AND end_date >= ?) OR (start_date <= ? AND end_date >= ?))',
                            room_id, end_date, start_date, end_date, start_date])
      errors.add(:base, 'Já existe um preço para este quarto durante este período.')
    end
  end
  
end
