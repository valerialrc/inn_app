require 'rails_helper'

describe 'Dono visualiza avaliações' do
  it 'no menu' do
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

    review = Review.create!(reservation: reservation, score: 5, description: 'Excelente!')

    # Act
    login_as(user, :scope => :user)
    visit root_path
    within 'nav' do
      click_on 'Avaliações'
    end

    # Assert
    expect(current_path).to eq reviews_path()
    expect(page).to have_content 'Status da Reserva: Finalizada'
    expect(page).to have_content 'Nota: 5'
    expect(page).to have_content 'Comentário: Excelente!'
    expect(page).to have_link 'Responder Cliente'
  end

  it 'e visualiza página para resposta' do
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

    review = Review.create!(reservation: reservation, score: 5, description: 'Excelente!')

    # Act
    login_as(user, :scope => :user)
    visit root_path
    click_on 'Avaliações'
    room_cards = all('.room-card')
    within room_cards[0] do
      click_on 'Responder Cliente'
    end

    # Assert
    expect(current_path).to eq new_review_answer_path(review)
    expect(page).to have_field 'Comentário'
    expect(page).to have_button 'Enviar Resposta'
  end

  it 'e submete o campo de texto vazio' do
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

    review = Review.create!(reservation: reservation, score: 5, description: 'Excelente!')

    # Act
    login_as(user, :scope => :user)
    visit root_path
    click_on 'Avaliações'
    room_cards = all('.room-card')
    within room_cards[0] do
      click_on 'Responder Cliente'
    end
    click_on 'Enviar Resposta'

    # Assert
    expect(current_path).to eq review_answers_path(review)
    expect(page).to have_content 'Comentário não pode ficar em branco'
    expect(page).to have_button 'Enviar Resposta'
  end

  it 'e responde com sucesso' do
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

    review = Review.create!(reservation: reservation, score: 5, description: 'Excelente!')

    # Act
    login_as(user, :scope => :user)
    visit root_path
    click_on 'Avaliações'
    room_cards = all('.room-card')
    within room_cards[0] do
      click_on 'Responder Cliente'
    end
    fill_in 'Comentário', with: 'Obrigada!'
    click_on 'Enviar Resposta'

    # Assert
    expect(current_path).to eq reservation_path(reservation)
    expect(page).to have_content 'Resposta do Dono: Obrigada!'
    expect(page).not_to have_content 'Responder Cliente'
  end
end