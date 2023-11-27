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

    inn = Inn.new(user: user, trade_name: 'Pousada das Pedras',
                  legal_name: 'Pousada das Pedras LTDA', cnpj: '123456789',
                  phone: '(31)99999-9999', email: 'contato@pedras.com',
                  description: 'Pousada para a família',
                  payment_method: pm, accepts_pets: true, 
                  checkin_time: '13:00', checkout_time: '11:00',
                  policies: 'Boa convivência', active: true)
  
    address = inn.build_address(
      street: 'Rua das Pedras',
      number: 56,
      district: 'Centro',
      city: 'BH',
      state: 'MG',
      cep: '30000-000'
    )
    
    inn.save!

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

    second_inn = Inn.new(user: pedro, trade_name: 'Pousada das Palmeiras',
                    legal_name: 'Pousada das Palmeiras LTDA', cnpj: '987654321',
                    phone: '(31)11111-1111', email: 'contado@palmeiras.com',
                    description: 'Pousada para casais',
                    payment_method: pm2, accepts_pets: false, 
                    checkin_time: '13:00', checkout_time: '11:00',
                    policies: 'Boa convivência', active: true)
  
    second_address = second_inn.build_address(street: 'Rua das Palmeiras', number: 65,
                            district: 'Nova Palmeira', city: 'Boituva', state: 'SP',
                            cep: '50000-000', inn: second_inn)

    second_inn.save!
                          
    ana = User.create!(email: 'ana@email.com', password: 'password')

    third_inn = Inn.new(user: ana, trade_name: 'Pousada das Rosas',
                    legal_name: 'Pousada das Rosas LTDA', cnpj: '333333321',
                    phone: '(31)11111-2222', email: 'contado@rosas.com',
                    description: 'Pousada para casais',
                    payment_method: pm, accepts_pets: false, 
                    checkin_time: '13:00', checkout_time: '11:00',
                    policies: 'Boa convivência', active: true)
  
    third_address = third_inn.build_address(street: 'Rua das Palmeiras', number: 65,
                            district: 'Nova Palmeira', city: 'Boituva', state: 'SP',
                            cep: '50000-000', inn: third_inn)

    third_inn.save!
                        
    paula = User.create!(email: 'paula@email.com', password: 'password')

    fourth_inn = Inn.new(user: paula, trade_name: 'Pousada Silva',
                    legal_name: 'Pousada Silva LTDA', cnpj: '333333321',
                    phone: '(31)11111-2222', email: 'contado@rosas.com',
                    description: 'Pousada para casais',
                    payment_method: pm, accepts_pets: false, 
                    checkin_time: '13:00', checkout_time: '11:00',
                    policies: 'Boa convivência', active: true)
  
    fourth_address = fourth_inn.build_address(street: 'Rua das Palmeiras', number: 65,
                            district: 'Nova Palmeira', city: 'Boituva', state: 'SP',
                            cep: '50000-000', inn: fourth_inn)

    fourth_inn.save!

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

    inn = Inn.new(user: user, trade_name: 'Pousada das Pedras',
                  legal_name: 'Pousada das Pedras LTDA', cnpj: '123456789',
                  phone: '(31)99999-9999', email: 'contato@pedras.com',
                  description: 'Pousada para a família',
                  payment_method: pm, accepts_pets: true, 
                  checkin_time: '13:00', checkout_time: '11:00',
                  policies: 'Boa convivência', active: false)
  
    address = inn.build_address(
      street: 'Rua das Pedras',
      number: 56,
      district: 'Centro',
      city: 'BH',
      state: 'MG',
      cep: '30000-000'
    )
    
    inn.save!

    # Act
    visit root_path
    # Assert
    expect(page).not_to have_content('Mais Recentes')
    expect(page).to have_content('Não existem pousadas cadastradas')
  end
end