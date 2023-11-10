require 'rails_helper'

describe 'Usuário visita tela inicial' do
  it 'e vê o nome do app' do
    # Arrange

    # Act
    visit root_path

    # Assert
    expect(page).to have_content('Pousadaria')
  end

  it 'e vê as pousadas cadastradas que estão ativas' do
    # Arrange
    create_inn

    user = User.create!(email: 'pedro@email.com', password: 'password')

    pm = PaymentMethod.create!(name: 'Pix')
    pm2 = PaymentMethod.create!(name: 'Dinheiro')

    inn = Inn.create!(user: user, trade_name: 'Pousada das Palmeiras',
                    legal_name: 'Pousada das Palmeiras LTDA', cnpj: '987654321',
                    phone: '(31)11111-1111', email: 'contado@palmeiras.com',
                    description: 'Pousada para casais',
                    payment_method: pm2, accepts_pets: false, 
                    checkin_time: '13:00', checkout_time: '11:00',
                    policies: 'Boa convivência', active: false)
  
    address = Address.create!(street: 'Rua das Palmeiras', number: 65,
                            district: 'Nova Palmeira', city: 'Boituva', state: 'SP',
                            cep: '50000-000', inn: inn)

    # Act
    visit root_path

    # Assert
    expect(page).not_to have_content('Não existem pousadas cadastrados')
    expect(page).to have_content('Pousada das Pedras')
    expect(page).to have_content('Pousada para a família')
    expect(page).to have_content('Cidade: BH')
    expect(page).not_to have_content('Pousada das Palmeiras')
    expect(page).not_to have_content('Pousada para casais')
    expect(page).not_to have_content('Cidade: Boituva')
  end

  it 'e não existem pousadas ativas cadastradas' do 
    # Arrange
    user = User.create!(email: 'pedro@email.com', password: 'password')

    pm = PaymentMethod.create!(name: 'Pix')
    pm2 = PaymentMethod.create!(name: 'Dinheiro')

    inn = Inn.create!(user: user, trade_name: 'Pousada das Palmeiras',
                    legal_name: 'Pousada das Palmeiras LTDA', cnpj: '987654321',
                    phone: '(31)11111-1111', email: 'contado@palmeiras.com',
                    description: 'Pousada para casais',
                    payment_method: pm2, accepts_pets: false, 
                    checkin_time: '13:00', checkout_time: '11:00',
                    policies: 'Boa convivência', active: false)
  
    address = Address.create!(street: 'Rua das Palmeiras', number: 65,
                            district: 'Nova Palmeira', city: 'Boituva', state: 'SP',
                            cep: '50000-000', inn: inn)

    # Act
    visit root_path
    # Assert
    expect(page).to have_content('Não existem pousadas cadastradas')
  end
end