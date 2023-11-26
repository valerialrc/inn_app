require 'rails_helper'

describe 'Usuário visualiza média da pousada' do
  it 'na página de detalhes da pousada' do
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

    review = Review.create!(reservation: reservation, score: 5, description: 'Excelente estadia!')

    answer = Answer.create!(description: 'Obrigada!', user: user, review: review)

    # Act
    visit root_path
    click_on 'Pousada das Pedras'

    # Assert
    expect(page).to have_content 'Média: 5'
  end

  it 'e as 3 últimas avaliações' do
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

    first_review = Review.create!(reservation: reservation, score: 5, description: 'Excelente estadia!')
    second_review = Review.create!(reservation: reservation, score: 4, description: 'Boa estadia!')
    third_review = Review.create!(reservation: reservation, score: 3, description: 'Estadia ruim!')
    fourth_review = Review.create!(reservation: reservation, score: 2, description: 'Estadia péssima!')

    # Act
    visit root_path
    click_on 'Pousada das Pedras'

    # Assert
    expect(page).to have_content 'Média: 3.5'
    expect(page).not_to have_content 'Excelente estadia!'
    expect(page).to have_content 'Boa estadia!'
    expect(page).to have_content 'Estadia ruim!'
    expect(page).to have_content 'Estadia péssima!'
  end

  it 'e existe opção para ver todas as avaliações em outra página' do
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

    first_review = Review.create!(reservation: reservation, score: 5, description: 'Excelente estadia!')

    # Act
    visit root_path
    click_on 'Pousada das Pedras'

    # Assert
    expect(page).to have_content 'Média: 5'
    expect(page).to have_link 'Ver todas as avaliações'
  end

  it 'e navega para ver todas as avaliações' do
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
                        checkout_date:2.days.from_now, guests_number: 2, status: :closed)

    second_reservation = Reservation.create!(room: room, customer: customer, checkin_date: 3.days.from_now,
                        checkout_date: 4.days.from_now, guests_number: 2, status: :closed)

    third_reservation = Reservation.create!(room: room, customer: customer, checkin_date: 5.days.from_now,
                        checkout_date: 6.days.from_now, guests_number: 2, status: :closed)

    fourth_reservation = Reservation.create!(room: room, customer: customer, checkin_date: 7.days.from_now,
                        checkout_date: 8.days.from_now, guests_number: 2, status: :closed)

    first_review = Review.create!(reservation: reservation, score: 5, description: 'Excelente estadia!')
    second_review = Review.create!(reservation: second_reservation, score: 4, description: 'Boa estadia!')
    third_review = Review.create!(reservation: third_reservation, score: 3, description: 'Estadia ruim!')
    fourth_review = Review.create!(reservation: fourth_reservation, score: 2, description: 'Estadia péssima!')

    # Act
    visit root_path
    click_on 'Pousada das Pedras'
    click_on 'Ver todas as avaliações'

    # Assert
    expect(current_path).to eq inn_reviews_path(inn)
    expect(page).to have_content 'Excelente estadia!'
    expect(page).to have_content 'Boa estadia!'
    expect(page).to have_content 'Estadia ruim!'
    expect(page).to have_content 'Estadia péssima!'
  end
end
