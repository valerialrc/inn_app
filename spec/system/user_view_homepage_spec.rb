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
    pm = PaymentMethod.create!(name: 'Pix')
    pm2 = PaymentMethod.create!(name: 'Dinheiro')

    user = User.create!(email: 'pedro@email.com', password: 'password')

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
    expect(page).to have_selector('#recent_inns', text: 'Pousada das Pedras - BH')
    expect(page).not_to have_content('Não existem pousadas cadastrados')
    expect(page).to have_link('Pousada das Pedras - BH')
    expect(page).not_to have_link('Pousada das Palmeiras - Boituva')
  end

  it 'e vê pousadas ativas nas sessões mais recentes e outras' do
    # Arrange
    create_inn
    pm = PaymentMethod.create!(name: 'Pix')
    pm2 = PaymentMethod.create!(name: 'Dinheiro')

    pedro = User.create!(email: 'pedro@email.com', password: 'password')

    second_inn = Inn.create!(user: pedro, trade_name: 'Pousada das Palmeiras',
                    legal_name: 'Pousada das Palmeiras LTDA', cnpj: '987654321',
                    phone: '(31)11111-1111', email: 'contado@palmeiras.com',
                    description: 'Pousada para casais',
                    payment_method: pm2, accepts_pets: false, 
                    checkin_time: '13:00', checkout_time: '11:00',
                    policies: 'Boa convivência', active: true)
  
    second_address = Address.create!(street: 'Rua das Palmeiras', number: 65,
                            district: 'Nova Palmeira', city: 'Boituva', state: 'SP',
                            cep: '50000-000', inn: second_inn)
                          
    ana = User.create!(email: 'ana@email.com', password: 'password')

    third_inn = Inn.create!(user: ana, trade_name: 'Pousada das Rosas',
                    legal_name: 'Pousada das Rosas LTDA', cnpj: '333333321',
                    phone: '(31)11111-2222', email: 'contado@rosas.com',
                    description: 'Pousada para casais',
                    payment_method: pm, accepts_pets: false, 
                    checkin_time: '13:00', checkout_time: '11:00',
                    policies: 'Boa convivência', active: true)
  
    third_address = Address.create!(street: 'Rua das Palmeiras', number: 65,
                            district: 'Nova Palmeira', city: 'Boituva', state: 'SP',
                            cep: '50000-000', inn: third_inn)
                            
    paula = User.create!(email: 'paula@email.com', password: 'password')

    fourth_inn = Inn.create!(user: paula, trade_name: 'Pousada Silva',
                    legal_name: 'Pousada Silva LTDA', cnpj: '333333321',
                    phone: '(31)11111-2222', email: 'contado@rosas.com',
                    description: 'Pousada para casais',
                    payment_method: pm, accepts_pets: false, 
                    checkin_time: '13:00', checkout_time: '11:00',
                    policies: 'Boa convivência', active: true)
  
    fourth_address = Address.create!(street: 'Rua das Palmeiras', number: 65,
                            district: 'Nova Palmeira', city: 'Boituva', state: 'SP',
                            cep: '50000-000', inn: fourth_inn)

    # Act
    visit root_path

    # Assert
    expect(page).to have_selector('#other_inns', text: 'Pousada das Pedras - BH')
    expect(page).to have_selector('#recent_inns', text: 'Pousada das Palmeiras - Boituva')
    expect(page).to have_selector('#recent_inns', text: 'Pousada das Rosas - Boituva')
    expect(page).to have_selector('#recent_inns', text: 'Pousada Silva - Boituva')
    expect(page).not_to have_content('Não existem pousadas cadastrados')
    expect(page).to have_link('Pousada das Pedras - BH')
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
    expect(page).not_to have_content('Mais Recentes')
    expect(page).to have_content('Não existem pousadas cadastradas')
  end
end