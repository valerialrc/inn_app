require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe '#valid?' do
    it 'data de check-in não deve ser passada' do
      # Arrange
      reservation = Reservation.new(checkin_date: 1.day.ago, checkout_date: Date.today)
    
      # Act
      reservation.valid?
      result = reservation.errors.include?(:checkin_date)

      # Assert
      expect(result).to be true
      expect(reservation.errors[:checkin_date]).to include "deve ser futura."
    end

    it 'data de checkin deve ser igual ou maior que amanhã' do
      # Arrange
      reservation = Reservation.new(checkin_date: 1.day.from_now, checkout_date: 1.week.from_now)
    
      # Act
      reservation.valid?
      result = reservation.errors.include?(:checkin_date)

      # Assert
      expect(result).to be false
    end

    it 'data de check-out não deve ser passada' do
      # Arrange
      reservation = Reservation.new(checkin_date: 2.day.ago, checkout_date: 1.day.ago)
    
      # Act
      reservation.valid?
      result = reservation.errors.include?(:checkout_date)

      # Assert
      expect(result).to be true
      expect(reservation.errors[:checkout_date]).to include "deve ser futura."
    end

    it 'data de checkout não deve ser igual a data de checkin' do
      # Arrange
      reservation = Reservation.new(checkin_date: Date.today, checkout_date: Date.today)
    
      # Act
      reservation.valid?
      result = reservation.errors.include?(:checkout_date)

      # Assert
      expect(result).to be true
    end

    it 'data de checkout não deve ser menor que a data de checkin' do
      # Arrange
      reservation = Reservation.new(checkin_date: Date.today, checkout_date: 1.day.ago)
    
      # Act
      reservation.valid?
      result = reservation.errors.include?(:checkout_date)

      # Assert
      expect(result).to be true
    end

    it 'data de checkout deve ser maior que a data de checkin' do
      # Arrange
      reservation = Reservation.new(checkin_date: Date.today, checkout_date: 1.day.from_now)
    
      # Act
      reservation.valid?
      result = reservation.errors.include?(:checkout_date)

      # Assert
      expect(result).to be false
    end

    it 'não permite número de hóspedes maior que a capacidade' do
      # Arrange
      create_inn
      inn = Inn.first
      customer = Customer.new(full_name: 'João Silva', cpf: '11111111111',
                            email: 'joao@email.com', password: 'password')
  
      room = Room.create!(name: 'Quarto Premium',
                          description: 'Um quarto espaçoso e confortável',
                          dimension: 30.5, max_occupancy: 2, daily_rate: 200.0,
                          has_bathroom: true, has_balcony: false,
                          has_air_conditioning: true, has_tv: true,
                          has_wardrobe: true, has_safe: false, is_accessible: true,
                          is_available: true, inn: inn)

  
      # Act
      reservation = Reservation.new(room: room, customer: customer, checkin_date: 2.days.from_now,
                                    checkout_date:1.week.from_now, guests_number: 3)
      
  
      # Assert
      expect(reservation.valid?).to eq false
      expect(reservation.errors.full_messages).to eq ['O Número de Hóspedes é maior que a capacidade do quarto.']
    end

    it 'deve ter um código' do
      # Arrange
      create_inn
      inn = Inn.first
      customer = Customer.new(full_name: 'João Silva', cpf: '11111111111',
                            email: 'joao@email.com', password: 'password')
  
      room = Room.create!(name: 'Quarto Premium',
                          description: 'Um quarto espaçoso e confortável',
                          dimension: 30.5, max_occupancy: 2, daily_rate: 200.0,
                          has_bathroom: true, has_balcony: false,
                          has_air_conditioning: true, has_tv: true,
                          has_wardrobe: true, has_safe: false, is_accessible: true,
                          is_available: true, inn: inn)

      reservation = Reservation.new(room: room, customer: customer, checkin_date: 2.days.from_now,
                                    checkout_date:1.week.from_now, guests_number: 2)

      # Act
      result = reservation.valid?

      # Assert
      expect(result).to be true
    end
  end

  describe 'gera um código aleatório' do
    it 'ao criar uma nova reserva' do
      # Arrange
      create_inn
      inn = Inn.first
      customer = Customer.new(full_name: 'João Silva', cpf: '11111111111',
                            email: 'joao@email.com', password: 'password')
  
      room = Room.create!(name: 'Quarto Premium',
                          description: 'Um quarto espaçoso e confortável',
                          dimension: 30.5, max_occupancy: 2, daily_rate: 200.0,
                          has_bathroom: true, has_balcony: false,
                          has_air_conditioning: true, has_tv: true,
                          has_wardrobe: true, has_safe: false, is_accessible: true,
                          is_available: true, inn: inn)

      reservation = Reservation.new(room: room, customer: customer, checkin_date: 2.days.from_now,
                                    checkout_date:1.week.from_now, guests_number: 2)

      # Act
      reservation.save!
      result = reservation.code

      # Assert
      expect(result).not_to be_empty
      expect(result.length).to eq 8
    end

    it 'e o código é único' do
      # Arrange
      create_inn
      inn = Inn.first
      customer = Customer.new(full_name: 'João Silva', cpf: '11111111111',
                            email: 'joao@email.com', password: 'password')
  
      room = Room.create!(name: 'Quarto Premium',
                          description: 'Um quarto espaçoso e confortável',
                          dimension: 30.5, max_occupancy: 2, daily_rate: 200.0,
                          has_bathroom: true, has_balcony: false,
                          has_air_conditioning: true, has_tv: true,
                          has_wardrobe: true, has_safe: false, is_accessible: true,
                          is_available: true, inn: inn)

      first_reservation = Reservation.create!(room: room, customer: customer, checkin_date: 2.days.from_now,
                                              checkout_date:1.week.from_now, guests_number: 2)

      second_reservation = Reservation.new(room: room, customer: customer, checkin_date: 2.weeks.from_now,
                                           checkout_date: 3.weeks.from_now, guests_number: 2)
 
      # Act
      second_reservation.save!

      # Assert
      expect(second_reservation.code).not_to eq first_reservation.code
    end

    it 'e não deve ser modificado' do
      # Arrange
      create_inn
      inn = Inn.first
      customer = Customer.new(full_name: 'João Silva', cpf: '11111111111',
                            email: 'joao@email.com', password: 'password')
  
      room = Room.create!(name: 'Quarto Premium',
                          description: 'Um quarto espaçoso e confortável',
                          dimension: 30.5, max_occupancy: 2, daily_rate: 200.0,
                          has_bathroom: true, has_balcony: false,
                          has_air_conditioning: true, has_tv: true,
                          has_wardrobe: true, has_safe: false, is_accessible: true,
                          is_available: true, inn: inn)

      reservation = Reservation.create!(room: room, customer: customer, checkin_date: 2.days.from_now,
                                    checkout_date:1.week.from_now, guests_number: 2)

      original_code = reservation.code

      # Act
      reservation.update!(checkin_date: 3.days.from_now)

      # Assert
      expect(reservation.code).to eq original_code
    end
  end
end
