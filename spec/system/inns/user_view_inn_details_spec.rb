require 'rails_helper'

describe 'Usuário vê detalhes de um pousada' do
  it 'e vê informações adicionais' do 
    # Arrange
    user = User.create!(email: 'joao@email.com', password: 'password')

    pm = PaymentMethod.create!(name: 'Pix')
    pm2 = PaymentMethod.create!(name: 'Dinheiro')

    inn = Inn.create!(user: user, trade_name: 'Pousada das Pedras',
                      legal_name: 'Pousada das Pedras LTDA', cnpj: '123456789',
                      phone: '(31)99999-9999', email: 'contato@pedras.com',
                      description: 'Pousada para a família',
                      payment_method: pm, accepts_pets: true, 
                      checkin_time: '13:00', checkout_time: '11:00',
                      policies: 'Boa convivência', active: true)
                      
    address = Address.create!(street: 'Rua das Pedras', number: 56,
                              district: 'Centro', city: 'BH', state: 'MG',
                              cep: '30000-000', inn: inn)

    # Act
    visit root_path
    click_on('Pousada das Pedras')

    # Assert
    expect(page). to have_content('Pousada das Pedras')
    expect(page). to have_content('Descrição: Pousada para a família')
    expect(page). to have_content('Rua das Pedras, 56, Centro, BH, MG CEP: 30000-000')
    expect(page). to have_content('Forma de Pagamento: Pix')
    expect(page). to have_content('Aceita animais')
  end

  it 'e volta para a tela inicial' do
    # Arrange
    user = User.create!(email: 'joao@email.com', password: 'password')

    pm = PaymentMethod.create!(name: 'Pix')
    pm2 = PaymentMethod.create!(name: 'Dinheiro')

    inn = Inn.create!(user: user, trade_name: 'Pousada das Pedras',
                      legal_name: 'Pousada das Pedras LTDA', cnpj: '123456789',
                      phone: '(31)99999-9999', email: 'contato@pedras.com',
                      description: 'Pousada para a família',
                      payment_method: pm, accepts_pets: true, 
                      checkin_time: '13:00', checkout_time: '11:00',
                      policies: 'Boa convivência', active: true)
  
    address = Address.create!(street: 'Rua das Pedras', number: 56,
                              district: 'Centro', city: 'BH', state: 'MG',
                              cep: '30000-000', inn: inn)

    # Act
    visit root_path
    click_on 'Pousada das Pedras'
    click_on 'Voltar'

      # Assert
      expect(current_path).to eq('/')
    end
end