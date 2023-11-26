require 'rails_helper'

describe 'Cliente deseja avaliar a estadia' do
  it 'e procura a opção' do
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
                        checkout_date:1.week.from_now, guests_number: 2, status: :closed)

    # Act
    login_as(customer, :scope => :customer)
    visit root_path
    click_on 'Minhas Reservas'
    room_cards = all('.room-card')
    within room_cards[0] do
      click_on "Reserva #{reservation.code}"
    end

    # Assert
    expect(current_path).to eq inn_room_reservation_path(inn, room, reservation)
    expect(page).to have_content 'Status da Reserva: Finalizada'
    expect(Reservation.where(status: :closed).count).to eq 1
    expect(page).to have_link 'Avaliar Estadia'
  end

  it 'e visualiza a página com campo para nota e comentário' do
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
                        checkout_date:1.week.from_now, guests_number: 2, status: :closed)

    # Act
    login_as(customer, :scope => :customer)
    visit root_path
    click_on 'Minhas Reservas'
    room_cards = all('.room-card')
    within room_cards[0] do
      click_on "Reserva #{reservation.code}"
    end
    click_on "Avaliar Estadia"

    # Assert
    expect(current_path).to eq new_reservation_review_path(reservation)
    expect(page).to have_content 'Avaliar Estadia'
    expect(page).to have_field 'Avaliação'
    expect(page).to have_field 'Comentário'
  end

  it 'e avalia com sucesso' do
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
                        checkout_date:1.week.from_now, guests_number: 2, status: :closed)

    # Act
    login_as(customer, :scope => :customer)
    visit root_path
    click_on 'Minhas Reservas'
    room_cards = all('.room-card')
    within room_cards[0] do
      click_on "Reserva #{reservation.code}"
    end
    click_on "Avaliar Estadia"
    select '5', from: 'Avaliação (1 a 5)'
    fill_in 'Comentário', with: 'Excelente estadia!'
    click_button 'Enviar Avaliação'

    # Assert
    expect(Review.count).to eq(1)
    review = Review.first
    expect(review.score).to eq(5)
    expect(review.description).to eq('Excelente estadia!')
    expect(current_path).to eq reservation_path(reservation)
    expect(page).not_to have_content 'Avaliar Estadia'
    expect(page).to have_content 'Nota: 5'
    expect(page).to have_content 'Comentário: Excelente estadia!'
  end
end