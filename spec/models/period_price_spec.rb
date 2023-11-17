require 'rails_helper'

RSpec.describe PeriodPrice, type: :model do
  describe '#valid?' do
    it 'Não deve sobrepor datas' do
      # Arrange
      create_inn
      inn = Inn.find(1)

      room = Room.create!(name: 'Quarto Premium',
                          description: 'Um quarto espaçoso e confortável',
                          dimension: 30.5, max_occupancy: 2, daily_rate: 200.0,
                          has_bathroom: true, has_balcony: false,
                          has_air_conditioning: true, has_tv: true,
                          has_wardrobe: true, has_safe: false, is_accessible: true,
                          is_available:true, inn: inn)

      first_price = PeriodPrice.create!(room: room, start_date: '2023-01-01',
                                        end_date: '2023-01-07', daily_value: 150.00)

      second_price = PeriodPrice.new(room: room, start_date: '2023-01-06',
                                        end_date: '2023-01-10', daily_value: 150.00)
                          

      # Act
      second_price.save
      second_price.errors.full_messages
    
      # Assert
      expect(second_price.errors.full_messages).to eq ['Já existe um preço para este quarto durante este período.']
    end
  end
end
