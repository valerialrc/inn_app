require 'rails_helper'

describe 'Usuário vê menu de cidades' do
  it 'na tela inicial' do
    # Arrange
    joao = User.create!(email: 'joao@email.com', password: 'password')

    pm = PaymentMethod.create!(name: 'Pix')
    pm2 = PaymentMethod.create!(name: 'Dinheiro')

    inn = Inn.create!(user: joao, trade_name: 'Pousada das Pedras',
                      legal_name: 'Pousada das Pedras LTDA', cnpj: '123456789',
                      phone: '(31)99999-9999', email: 'contato@pedras.com',
                      description: 'Pousada para a família',
                      payment_method: pm, accepts_pets: true, 
                      checkin_time: '13:00', checkout_time: '11:00',
                      policies: 'Boa convivência', active: true)
    
    address = Address.create!(street: 'Rua das Pedras', number: 56,
                              district: 'Centro', city: 'BH', state: 'MG',
                              cep: '30000-000', inn: inn)

    ana = User.create!(email: 'ana@email.com', password: 'password')

    other_inn = Inn.create!(user: ana, trade_name: 'Pousada das Cachoeiras',
                      legal_name: 'Pousada das Cachoeiras LTDA', cnpj: '987654321',
                      phone: '(31)99999-1111', email: 'contato@cachoeiras.com',
                      description: 'Pousada para a família',
                      payment_method: pm2, accepts_pets: true, 
                      checkin_time: '13:00', checkout_time: '11:00',
                      policies: 'Boa convivência', active: true)
    
    other_address = Address.create!(street: 'Rua das Cachoeiras', number: 56,
                              district: 'Centro', city: 'Ubá', state: 'MG',
                              cep: '30000-050', inn: other_inn)

    # Act
    visit root_path

    # Assert
    expect(page).to have_selector('#cities') do |section|
      expect(section).to have_content('Cidades')
      expect(section).to have_link('BH', href: city_path('BH'))
      expect(section).to have_link('Ubá', href: city_path('Ubá'))
    end
  end

  it 'e vê listas de pousadas daquela cidade em ordem alfabética' do
    # Arrange
    joao = User.create!(email: 'joao@email.com', password: 'password')

    pm = PaymentMethod.create!(name: 'Pix')
    pm2 = PaymentMethod.create!(name: 'Dinheiro')

    inn = Inn.create!(user: joao, trade_name: 'Pousada das Pedras',
                      legal_name: 'Pousada das Pedras LTDA', cnpj: '123456789',
                      phone: '(31)99999-9999', email: 'contato@pedras.com',
                      description: 'Pousada para a família',
                      payment_method: pm, accepts_pets: true, 
                      checkin_time: '13:00', checkout_time: '11:00',
                      policies: 'Boa convivência', active: true)
    
    address = Address.create!(street: 'Rua das Pedras', number: 56,
                              district: 'Centro', city: 'BH', state: 'MG',
                              cep: '30000-000', inn: inn)

    ana = User.create!(email: 'ana@email.com', password: 'password')

    other_inn = Inn.create!(user: ana, trade_name: 'Pousada das Cachoeiras',
                      legal_name: 'Pousada das Cachoeiras LTDA', cnpj: '987654321',
                      phone: '(31)99999-1111', email: 'contato@cachoeiras.com',
                      description: 'Pousada para a família',
                      payment_method: pm2, accepts_pets: true, 
                      checkin_time: '13:00', checkout_time: '11:00',
                      policies: 'Boa convivência', active: true)
    
    other_address = Address.create!(street: 'Rua das Cachoeiras', number: 56,
                              district: 'Centro', city: 'BH', state: 'MG',
                              cep: '30000-050', inn: other_inn)

    # Act
    visit root_path
    click_on 'BH'

    # Assert
    expect(page).to have_content 'Pousadas em BH'
    expect(page).to have_link 'Pousada das Pedras'
    expect(page).to have_content 'Pousada das Cachoeiras Pousada das Pedras'
  end
end