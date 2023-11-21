require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

describe 'Usuário quer cancelar reserva' do
  it 'e está no prazo de 7 dias' do
    # Arrange
    create_inn
    inn = Inn.first

    room = Room.create!(name: 'Quarto Premium',
                        description: 'Um quarto espaçoso e confortável',
                        dimension: 30.5, max_occupancy: 2, daily_rate: 200.0,
                        has_bathroom: true, has_balcony: false,
                        has_air_conditioning: true, has_tv: true,
                        has_wardrobe: true, has_safe: false, is_accessible: true,
                        is_available: true, inn: inn)

    customer = Customer.create!(full_name: 'João Silva', cpf: '11111111111',
                                email: 'joao@email.com', password: 'password')

    reservation = Reservation.create!(room: room, customer: customer, checkin_date: 1.day.from_now,
                        checkout_date:1.week.from_now, guests_number: 2, status: :confirmed)

    # Act
    login_as(customer)
    visit root_path
    click_on 'Minhas Reservas'
    room_cards = all('.room-card')
    within room_cards[0] do
      click_on 'Cancelar Reserva'
    end

    # Assert
    expect((reservation.created_at + 7.days).after?(Time.zone.now)).to eq true
    expect(current_path).to eq reservations_path
    expect(page).to have_content 'Status da Reserva: Cancelada'
    expect(page).not_to have_content 'Cancelar Reserva'
    expect(Reservation.where(status: :canceled).count).to eq 1
  end

  it 'e passou o prazo' do
      # Arrange
      create_inn
      inn = Inn.first
  
      room = Room.create!(name: 'Quarto Premium',
                          description: 'Um quarto espaçoso e confortável',
                          dimension: 30.5, max_occupancy: 2, daily_rate: 200.0,
                          has_bathroom: true, has_balcony: false,
                          has_air_conditioning: true, has_tv: true,
                          has_wardrobe: true, has_safe: false, is_accessible: true,
                          is_available: true, inn: inn)
  
      customer = Customer.create!(full_name: 'João Silva', cpf: '11111111111',
                                  email: 'joao@email.com', password: 'password')
  
      reservation = Reservation.create!(room: room, customer: customer, checkin_date: 1.day.from_now,
                          checkout_date:1.week.from_now, guests_number: 2, status: :confirmed)
  
      # Act
      login_as(customer)
      visit root_path
      travel_to 8.days.from_now
      click_on 'Minhas Reservas'
  
      # Assert
      expect((reservation.created_at + 7.days).after?(Time.zone.now)).to eq false
      expect(current_path).to eq reservations_path
      expect(page).to have_content 'Status da Reserva: Confirmada'
      expect(page).not_to have_content 'Cancelar Reserva'
      travel_back    
  end
end