require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

describe 'Dono quer mudar status da reserva' do
  it 'para cancelada e já se passaram 2 dias do checkin' do
    # Arrange
    create_inn
    inn = Inn.first
    user = User.first

    room = Room.create!(name: 'Quarto Premium',
                        description: 'Um quarto espaçoso e confortável',
                        dimension: 30.5, max_occupancy: 2, daily_rate: 200.0,
                        has_bathroom: true, has_balcony: false,
                        has_air_conditioning: true, has_tv: true,
                        has_wardrobe: true, has_safe: false, is_accessible: true,
                        is_available: true, inn: inn)

    customer = Customer.create!(full_name: 'João Silva', cpf: '11111111111',
                                email: 'joao@email.com', password: 'password')

    reservation = Reservation.create!(room: room, customer: customer, checkin_date: 1.days.from_now,
                        checkout_date:1.week.from_now, guests_number: 2, status: :confirmed)

    # Act
    login_as(user, :scope => :user)
    visit root_path
    travel_to 3.days.from_now
    click_on 'Reservas'
    room_cards = all('.room-card')
    within room_cards[0] do
      click_on 'Cancelar Reserva'
    end

    # Assert
    expect((reservation.checkin_date + 2.days).before?(Time.zone.now)).to eq true
    expect(current_path).to eq reservations_path
    expect(page).to have_content 'Status da Reserva: Cancelada'
    expect(page).not_to have_content 'Cancelar Reserva'
    expect(Reservation.where(status: :canceled).count).to eq 1
    travel_back
  end

  it 'para cancelada e não passaram dois dias do checkin' do
      # Arrange
      create_inn
      inn = Inn.first
      user = User.first
  
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
      login_as(user, :scope => :user)
      visit root_path
      click_on 'Reservas'
  
      # Assert
      expect((reservation.checkin_date + 2.days).before?(Time.zone.now)).to eq false
      expect(current_path).to eq reservations_path
      expect(page).to have_content 'Status da Reserva: Confirmada'
      expect(page).not_to have_content 'Cancelar Reserva'
  end

  it 'para ativa ou cancelada e data obedece as regras' do
    # Arrange
    create_inn
    inn = Inn.first
    user = User.first

    room = Room.create!(name: 'Quarto Premium',
                        description: 'Um quarto espaçoso e confortável',
                        dimension: 30.5, max_occupancy: 2, daily_rate: 200.0,
                        has_bathroom: true, has_balcony: false,
                        has_air_conditioning: true, has_tv: true,
                        has_wardrobe: true, has_safe: false, is_accessible: true,
                        is_available: true, inn: inn)

    customer = Customer.create!(full_name: 'João Silva', cpf: '11111111111',
                                email: 'joao@email.com', password: 'password')

    reservation = Reservation.create!(room: room, customer: customer, checkin_date: 1.days.from_now,
                        checkout_date:1.week.from_now, guests_number: 2, status: :confirmed)

    # Act
    login_as(user, :scope => :user)
    visit root_path
    travel_to 8.days.from_now
    click_on 'Reservas'

    # Assert
    room_cards = all('.room-card')
    within room_cards[0] do
      expect(page).to have_content 'Cancelar Reserva'
      expect(page).to have_content 'Realizar Check-in do Cliente'
    end
    expect(page).to have_content 'Status da Reserva: Confirmada'
    travel_back
  end
end