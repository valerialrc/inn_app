require 'rails_helper'

describe 'Dono de pousada visualiza as reservas' do
  it 'após se autenticar' do
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
    expect(current_path).to eq reservations_path
  end

  it 'e não possui reservas' do
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

    # Act
    login_as(user, :scope => :user)
    visit root_path
    click_on 'Reservas'

    # Assert
    expect(page).to have_content 'Sua pousada ainda não possui reservas.'
  end

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

    Reservation.create!(room: room, customer: customer, checkin_date: 1.day.from_now,
                        checkout_date:1.week.from_now, guests_number: 2)

    Reservation.create!(room: room, customer: customer, checkin_date: 2.weeks.from_now,
                        checkout_date:1.month.from_now, guests_number: 2)

    # Act
    login_as(user, :scope => :user)
    visit root_path
    click_on 'Reservas'

    # Assert
    expect(page).to have_content('Quarto Premium', count: 2)
    room_cards = all('.room-card')
    within room_cards[0] do
      expect(page).to have_content "Data de Check-in: #{I18n.localize(1.day.from_now.to_date)}"
      expect(page).to have_content "Data de Check-out: #{I18n.localize(1.week.from_now.to_date)}"
    end
    within room_cards[1] do
      expect(page).to have_content "Data de Check-in: #{I18n.localize(2.weeks.from_now.to_date)}"
      expect(page).to have_content "Data de Check-out: #{I18n.localize(1.month.from_now.to_date)}"
    end
  end
end