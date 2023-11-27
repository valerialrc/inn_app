require 'rails_helper'

describe "Usuário busca por uma pousada" do
  it 'a partir do menu' do
    # Arrange
    user = User.create!(email: 'joao@email.com', password: 'password')

    # Act
    visit root_path

    # Assert
    within('header nav') do
      expect(page).to have_field 'Buscar Pousada'
      expect(page).to have_button('Buscar')
    end
  end

  it 'e encontra uma pousada' do
    # Arrange
    create_inn

    # Act
    visit root_path
    fill_in 'Buscar Pousada', with: 'Pousada das Pedras'
    click_on 'Buscar'

    # Assert
    expect(page).to have_content "Resultados da Busca por: Pousada das Pedras"
    expect(page).to have_content '1 pousada encontrada'
    expect(page).to have_link "Pousada das Pedras"
  end

  it 'e encontra múltiplos pousadas' do
    # Arrange
    create_inn
    pm = PaymentMethod.create!(name: 'Pix')
    pm2 = PaymentMethod.create!(name: 'Dinheiro')

    ana = User.create!(email: 'ana@email.com', password: 'password')

    other_inn = Inn.new(user: ana, trade_name: 'Pousada das Cachoeiras',
                        legal_name: 'Pousada das Cachoeiras LTDA', cnpj: '987654321',
                        phone: '(31)99999-1111', email: 'contato@cachoeiras.com',
                        description: 'Pousada para a família',
                        payment_method: pm, accepts_pets: true, 
                        checkin_time: '13:00', checkout_time: '11:00',
                        policies: 'Boa convivência', active: true)
      
    other_address = other_inn.build_address(street: 'Rua das Cachoeiras', number: 56,
                                            district: 'Centro', city: 'Ubá', state: 'MG',
                                            cep: '30000-050', inn: other_inn)
                          
    other_inn.save!

    # Act
    visit root_path
    fill_in 'Buscar Pousada', with: 'Centro'
    click_on 'Buscar'

    # Assert
    expect(page).to have_content "Resultados da Busca por: Centro"
    expect(page).to have_content '2 pousadas encontradas'
    expect(page).to have_link "Pousada das Pedras"
    expect(page).to have_link "Pousada das Cachoeiras"
    expect(page).to have_content "Pousada das Cachoeiras Pousada das Pedras"
  end
  
end
