require 'rails_helper'

describe 'Usuário visita tela inicial' do
  it 'e vê o nome do app' do
    # Arrange

    # Act
    visit root_path

    # Assert
    expect(page).to have_content('Pousadaria')
  end

  it 'e vê as pousadas cadastrados' do
    # Arrange
    user = User.create!(email: 'joao@email.com', password: 'password')

    pm = PaymentMethod.create!(name: 'Pix')
    pm2 = PaymentMethod.create!(name: 'Dinheiro')

    inn = Inn.create!(user: user, trade_name: 'Pousada das Pedras',
                      legal_name: 'Pousada das Pedras LTDA', cnpj: 'CNPJ',
                      phone: '(31)99999-9999', email: 'contado@pedras.com',
                      description: 'Pousada para a família',
                      payment_method: pm, accepts_pets: true, 
                      checkin_time: '13:00', checkout_time: '11:00',
                      policies: 'Boa convivência', active: true)

    address = Address.create!(street: 'Rua das Pedras', number: 56,
                              district: 'Centro', city: 'BH', state: 'MG',
                              cep: '30000-000', inn: inn)

    # Act
    visit root_path

    # Assert
    expect(page).not_to have_content('Não existem pousadas cadastrados')
    expect(page).to have_content('Pousada das Pedras')
    expect(page).to have_content('Pousada para a família')
    expect(page).to have_content('Cidade: BH')
  end

  it 'e não existem pousadas cadastradas' do 
    # Arrange

    # Act
    visit root_path
    # Assert
    expect(page).to have_content('Não existem galpões cadastrados')
  end
end