require 'rails_helper'

describe 'Cliente faz reserva' do
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

    customer = Customer.create!(full_name: 'João Silva', cpf: '11111111111',
                        email: 'joao@email.com', password: 'password')

    # Act
    visit root_path
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
    within('main form') do
      fill_in 'E-mail', with: 'joao@email.com'
      fill_in 'Senha', with: 'password'
      click_on 'Entrar'
    end

    # Assert
    expect(page).to have_content('Reserva confirmada com sucesso!')
    expect(page).to have_content('Total a Pagar: R$ 1.400,00')
  end

  it 'e não é salva no banco de dados até confirmar' do
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

    customer = Customer.create!(full_name: 'João Silva', cpf: '11111111111',
                                email: 'joao@email.com', password: 'password')

    # Act
    visit root_path
    click_on('Pousada das Pedras')
    room_cards = all('.room-card')
    within room_cards[0] do
      click_button('Reservar')
    end
    fill_in 'Data de Check-in', with: '01/01/2025'
    fill_in 'Data de Check-out', with: '08/01/2025'
    fill_in 'Número de Hóspedes', with: '2'
    click_on 'Verificar Disponibilidade'

    # Assert
    expect(Reservation.all.length).to eq 0
    expect(page).to have_content('Total a Pagar: R$ 1.400,00')
    expect(page).to have_content('Quarto: Quarto Premium - Pousada das Pedras')
    expect(page).to have_content('Forma de Pagamento: Pix')
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

    customer = Customer.create!(full_name: 'João Silva', cpf: '11111111111',
                                email: 'joao@email.com', password: 'password')

    allow(SecureRandom).to receive(:alphanumeric).and_return('ABC12345')

    # Act
    visit root_path
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
    within('main form') do
      fill_in 'E-mail', with: 'joao@email.com'
      fill_in 'Senha', with: 'password'
      click_on 'Entrar'
    end

    # Assert
    expect(page).to have_content 'Reserva ABC12345'
    expect(page).to have_content('Reserva confirmada com sucesso!')
    expect(page).to have_content('Total a Pagar: R$ 1.250,00')
  end

  it 'e não sobrepõe reservas' do
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

    Reservation.create!(room: room, customer: customer, checkin_date: 1.day.from_now,
                        checkout_date:1.week.from_now, guests_number: 2)

    # Act
    visit root_path
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

  it 'com dados incompletos' do
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

    customer = Customer.create!(full_name: 'João Silva', cpf: '11111111111',
                                email: 'joao@email.com', password: 'password')

    # Act
    visit root_path
    click_on('Pousada das Pedras')
    room_cards = all('.room-card')
    within room_cards[0] do
      click_button('Reservar')
    end
    fill_in 'Data de Check-in', with: ''
    fill_in 'Data de Check-out', with: ''
    fill_in 'Número de Hóspedes', with: ''
    click_on 'Verificar Disponibilidade'

    # Assert
    expect(page).to have_content('Data de Check-in não pode ficar em branco')
    expect(page).to have_content('Data de Check-out não pode ficar em branco')
    expect(page).to have_content('Número de Hóspedes não pode ficar em branco')
  end
end