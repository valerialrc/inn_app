require 'rails_helper'

describe 'Usuário edita uma Pousada' do
  it 'a partir da página de detalhes' do
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
    click_on 'Editar'

    # Assert
    expect(page).to have_content('Editar Pousada')
    expect(page).to have_field('Nome Fantasia', with: 'Pousada das Pedras')
    expect(page).to have_field('Razão Social', with: 'Pousada das Pedras LTDA')
    expect(page).to have_field('CNPJ', with: '123456789')
    expect(page).to have_field('Telefone', with: '(31)99999-9999')
    expect(page).to have_field('E-mail', with: 'contato@pedras.com')
    expect(page).to have_field('Descrição', with: 'Pousada para a família')
    expect(page).to have_field('Rua', with: 'Rua das Pedras')
    expect(page).to have_field('Número', with: '56')
    expect(page).to have_field('Bairro', with: 'Centro')
    expect(page).to have_field('Cidade', with: 'BH')
    expect(page).to have_field('Estado', with: 'MG')
    expect(page).to have_field('CEP', with: '30000-000')
    expect(page).to have_select("Forma de Pagamento", selected: pm.name)
    expect(page).to have_checked_field('Aceita pets')
    expect(page).to have_field('Horário de Check-in', with: '13:00:00.000')
    expect(page).to have_field('Horário de Check-out', with: '11:00:00.000')
    expect(page).to have_field('Políticas de Uso', with: 'Boa convivência')
  end

  it 'com sucesso' do
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
    click_on 'Editar'
    fill_in 'E-mail', with: 'pousada@pedras.com'
    select pm2.name, from: 'Forma de Pagamento'
    uncheck 'Aceita pets'
    fill_in 'Horário de Check-in', with: '12:00:00.000'
    fill_in 'Número', with: '42'
    click_on 'Salvar'

    # Assert
    expect(page).to have_content('Pousada atualizada com sucesso!')
    expect(page).to have_content('E-mail: pousada@pedras.com')
    expect(page).to have_content('Forma de Pagamento: Dinheiro')
    expect(page).to have_content('Não aceita animais')
    expect(page).to have_content('Horário de Check-in: 12:00')
    expect(page). to have_content 'Rua das Pedras, 42, Centro, BH, MG CEP: 30000-000'

  end

  it 'e mantem os campos obrigatórios' do
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
    click_on 'Editar'
    fill_in 'E-mail', with: ''
    select pm2.name, from: 'Forma de Pagamento'
    fill_in 'Horário de Check-in', with: ''
    fill_in 'Número', with: ''
    click_on 'Salvar'

    # Assert
    expect(page).to have_content('Não foi possível atualizar a pousada')
  end
end