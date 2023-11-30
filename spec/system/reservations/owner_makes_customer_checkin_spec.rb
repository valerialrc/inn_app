require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

describe 'Dono quer fazer check-in do cliente' do
  it 'e faz com sucesso' do
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
    travel_to 1.days.from_now
    click_on 'Reservas'
    room_cards = all('.room-card')
    within room_cards[0] do
      click_on 'Realizar Check-in do Cliente'
    end

    # Assert
    expect((reservation.checkin_date).before?(Time.zone.now)).to eq true
    expect(current_path).to eq active_reservations_path
    expect(page).to have_content 'Status da Reserva: Ativa'
    expect(page).not_to have_content 'Realizar Check-in do Cliente'
    expect(Reservation.where(status: :active).count).to eq 1
    expect(ActiveReservation.all.length).to eq 1
    expect(ActiveReservation.first.checkin_date).to eq Time.now
    travel_back
  end

  it 'mas a data atual é antes da data da reserva' do
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

    reservation = Reservation.create!(room: room, customer: customer, checkin_date: 2.days.from_now.in_time_zone,
                        checkout_date:1.week.from_now, guests_number: 2, status: :confirmed)

    # Act
    login_as(user, :scope => :user)
    visit root_path
    click_on 'Reservas'
    room_cards = all('.room-card')
    within room_cards[0] do
      click_on 'Realizar Check-in do Cliente'
    end

    # Assert
    expect((reservation.checkin_date).before?(Time.zone.now.to_date)).to eq false
    expect(current_path).to eq reservations_path
    expect(page).to have_content 'Status da Reserva: Confirmada'
    expect(page).to have_content 'Você só pode fazer check-in do cliente a partir da data da reserva.'
  end
end