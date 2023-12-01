require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

describe 'Dono cadastra item consumido' do
  it 'no card de detalhes da reserva' do
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
    expect(current_path).to eq active_reservations_path
    expect(page).to have_field 'Descrição'
    expect(page).to have_field 'Preço'
    expect(page).not_to have_content 'Itens Consumidos'
    expect(page).to have_button 'Adicionar Item Consumido'
    travel_back
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

    reservation = Reservation.create!(room: room, customer: customer, checkin_date: 1.day.from_now,
                        checkout_date:1.week.from_now, guests_number: 2, status: :confirmed)

    # Act
    login_as(user, :scope => :user)
    visit root_path
    travel_to 1.day.from_now
    click_on 'Reservas'
    room_cards = all('.room-card')
    within room_cards[0] do
      click_on 'Realizar Check-in do Cliente'
    end
    travel_to 2.days.from_now
    fill_in "Descrição",	with: "Guaraná 600ml" 
    fill_in "Preço",	with: 8 
    click_on 'Adicionar Item Consumido'
    
    # Assert
    expect(current_path).to eq reservation_path(reservation.id)
    expect(page).to have_content 'Status da Reserva: Ativa'
    expect(page).not_to have_content 'Realizar Check-in do Cliente'
    expect(page).to have_field 'Descrição'
    expect(page).to have_field 'Preço'
    expect(page).to have_button 'Adicionar Item Consumido'
    expect(page).to have_content 'Guaraná 600ml'
    expect(page).to have_content 'R$ 8,00'
    expect(page).to have_content 'Realizar Check-out do Cliente'
    expect(page).not_to have_content 'Consumo Total: R$ 8,00'
    travel_back
  end

  it 'e calcula preço final no checkout' do
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
    travel_to 1.day.from_now
    click_on 'Reservas'
    room_cards = all('.room-card')
    within room_cards[0] do
      click_on 'Realizar Check-in do Cliente'
    end
    travel_to 2.days.from_now
    fill_in "Descrição",	with: "Guaraná 600ml" 
    fill_in "Preço",	with: 8 
    click_on 'Adicionar Item Consumido'
    click_on 'Realizar Check-out do Cliente'
    
    
    # Assert
    expect(current_path).to eq closed_reservations_path
    expect(page).to have_content 'Status da Reserva: Finalizada'
    expect(page).not_to have_content 'Realizar Check-in do Cliente'
    expect(page).not_to have_field 'Descrição'
    expect(page).not_to have_field 'Preço'
    expect(page).not_to have_button 'Adicionar Item Consumido'
    expect(page).to have_content 'Guaraná 600ml'
    expect(page).to have_content 'R$ 8,00'
    expect(page).to have_content 'Consumo Total: R$ 8,00'
    travel_back
  end
end