require 'rails_helper'

describe 'Usuário faz reserva' do
  it 'a partir da página de detalhes da pousada' do
    # Arrange
    create_inn
    inn = Inn.find(1)

    room = Room.create!(name: 'Quarto Premium',
                        description: 'Um quarto espaçoso e confortável',
                        dimension: 30.5, max_occupancy: 2, daily_rate: 200.0,
                        has_bathroom: true, has_balcony: false,
                        has_air_conditioning: true, has_tv: true,
                        has_wardrobe: true, has_safe: false, is_accessible: true,
                        is_available: true, inn: inn)

    # Act
    visit root_path
    login
    click_on('Pousada das Pedras')
    room_cards = all('.room-card')
    within room_cards[0] do
      click_button('Reservar')
    end
    fill_in 'Data de Check-in', with: '01/01/2025'
    fill_in 'Data de Check-out', with: '08/01/2025'
    fill_in 'Número de Hóspedes', with: '2'
    click_on 'Verificar Disponibilidade'
    click_on 'Confirmar Reserva'

    # Assert
    expect(page).to have_content('Reserva confirmada com sucesso!')
    expect(page).to have_content('Total a Pagar: R$ 1.400,00')
  end

  it 'a partir da página de detalhes da pousada com preço por período cadastrado' do
    # Arrange
    create_inn
    inn = Inn.find(1)

    room = Room.create!(name: 'Quarto Premium',
                        description: 'Um quarto espaçoso e confortável',
                        dimension: 30.5, max_occupancy: 2, daily_rate: 200.0,
                        has_bathroom: true, has_balcony: false,
                        has_air_conditioning: true, has_tv: true,
                        has_wardrobe: true, has_safe: false, is_accessible: true,
                        is_available: true, inn: inn)

    p = PeriodPrice.create!(room: room, start_date: '2025-01-01',
                            end_date: '2025-01-07', daily_value: 150.00)

    # Act
    visit root_path
    login
    click_on('Pousada das Pedras')
    room_cards = all('.room-card')
    within room_cards[0] do
      click_button('Reservar')
    end
    fill_in 'Data de Check-in', with: '01/01/2025'
    fill_in 'Data de Check-out', with: '09/01/2025'
    fill_in 'Número de Hóspedes', with: '2'
    click_on 'Verificar Disponibilidade'
    click_on 'Confirmar Reserva'

    # Assert
    expect(page).to have_content('Reserva confirmada com sucesso!')
    expect(page).to have_content('Total a Pagar: R$ 1.250,00')
  end

  it 'e não sobrepõe reservas' do
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

    Reservation.create!(room: room, user: user, checkin_date: 1.day.from_now,
                        checkout_date:1.week.from_now, guests_number: 2,
                        total_price: 150.0)

    # Act
    visit root_path
    login
    click_on('Pousada das Pedras')
    room_cards = all('.room-card')
    within room_cards[0] do
      click_button('Reservar')
    end
    fill_in 'Data de Check-in', with: 2.days.from_now
    fill_in 'Data de Check-out', with: 8.days.from_now
    fill_in 'Número de Hóspedes', with: '2'
    click_on 'Verificar Disponibilidade'

    # Assert
    expect(page).to have_content('Já existe uma reserva para este quarto durante este período.')
    expect(page).to have_field('Número de Hóspedes', with: 2)
  end
end