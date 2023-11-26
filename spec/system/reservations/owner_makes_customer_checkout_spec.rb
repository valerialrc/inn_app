require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

describe 'Dono faz check-out do cliente' do
  it 'com sucesso' do
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
                        checkout_date:1.week.from_now, guests_number: 2, status: :active)

    travel_to 1.day.from_now
    ActiveReservation.create!(reservation: reservation, checkin_date: Time.zone.now)
    travel_to 1.minute.from_now

    # Act
    login_as(user, :scope => :user)
    visit root_path
    click_on 'Estadias Ativas'
    room_cards = all('.room-card')
    within room_cards[0] do
      click_on 'Realizar Check-out do Cliente'
    end

    # Assert
    expect(current_path).to eq closed_reservations_path
    expect(page).to have_content 'Estadias Finalizadas'
    expect(page).to have_content 'Status da Reserva: Finalizada'
    expect(page).not_to have_content 'Realizar Check-out do Cliente'
    expect(page).to have_content 'Total a Pagar: R$ 200,00'
    expect(page).to have_content 'Forma de Pagamento: Pix'
    expect(Reservation.where(status: :closed).count).to eq 1
    expect(ActiveReservation.all.length).to eq 1
    expect(ActiveReservation.first.checkout_date).to eq Time.now
    travel_back
  end
end