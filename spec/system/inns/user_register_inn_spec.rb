require 'rails_helper'

describe 'Usuário cadastra uma Pousada' do
  it 'após se cadastrar' do
    # Arrange

    # Act
    visit root_path
    sign_up
    
    # Assert
    expect(page).to have_content('Nova Pousada')
    expect(page).to have_field('Nome Fantasia')
    expect(page).to have_field('Razão Social')
    expect(page).to have_field('CNPJ')
    expect(page).to have_field('Telefone')
    expect(page).to have_field('E-mail')
    expect(page).to have_field('Descrição')
    expect(page).to have_field('Rua')
    expect(page).to have_field('Número')
    expect(page).to have_field('Bairro')
    expect(page).to have_field('Cidade')
    expect(page).to have_field('Estado')
    expect(page).to have_field('CEP')
    expect(page).to have_field('Forma de Pagamento')
    expect(page).to have_field('Aceita pets')
    expect(page).to have_field('Horário de Check-in')
    expect(page).to have_field('Horário de Check-out')
    expect(page).to have_field('Políticas de Uso')
  end

  it 'com sucesso' do
    # Arrange
    pm = PaymentMethod.create!(name: 'Pix')
    pm2 = PaymentMethod.create!(name: 'Dinheiro')

    # Act
    visit root_path
    sign_up
    fill_in 'Nome Fantasia', with: 'Pousada das Pedras'
    fill_in 'Razão Social', with: 'Pousada das Pedras LTDA'
    fill_in 'CNPJ', with: '123456789'
    fill_in 'Telefone', with: '(31)99999-9999'
    fill_in 'E-mail', with: 'contato@pedras.com'
    fill_in 'Descrição', with: 'Pousada para a família'
    fill_in 'Rua', with: 'Rua das Pedras'
    fill_in 'Número', with: '56'
    fill_in 'Bairro', with: 'Centro'
    fill_in 'Cidade', with: 'BH'
    fill_in 'Estado', with: 'MG'
    fill_in 'CEP', with: '30000-000'
    select pm.name, from: 'Forma de Pagamento'
    check 'Aceita pets'
    fill_in 'Horário de Check-in', with: '13:00'
    fill_in 'Horário de Check-out', with: '11:00'
    fill_in 'Políticas de Uso', with: 'Boa convivência'
    check 'Está ativa?'
    click_on 'Salvar'
  
    # Assert
    expect(page).to have_content 'Pousada cadastrada com sucesso!'
    expect(page).to have_content 'Pousada das Pedras'
    expect(page).to have_content 'Descrição: Pousada para a família'
    expect(page).to have_content 'Rua das Pedras, 56, Centro, BH, MG CEP: 30000-000'
    expect(page).to have_content 'Forma de Pagamento: Pix'
    expect(page).to have_content 'Aceita animais'
    expect(current_path).to eq '/inns/1'
  end
  
  it 'que não aceita animais com sucesso' do
    # Arrange
    pm = PaymentMethod.create!(name: 'Pix')
    pm2 = PaymentMethod.create!(name: 'Dinheiro')

    # Act
    visit root_path
    sign_up
    fill_in 'Nome Fantasia', with: 'Pousada das Pedras'
    fill_in 'Razão Social', with: 'Pousada das Pedras LTDA'
    fill_in 'CNPJ', with: '123456789'
    fill_in 'Telefone', with: '(31)99999-9999'
    fill_in 'E-mail', with: 'contato@pedras.com'
    fill_in 'Descrição', with: 'Pousada para a família'
    fill_in 'Rua', with: 'Rua das Pedras'
    fill_in 'Número', with: 56
    fill_in 'Bairro', with: 'Centro'
    fill_in 'Cidade', with: 'BH'
    fill_in 'Estado', with: 'MG'
    fill_in 'CEP', with: '30000-000'
    select 'Pix', from: 'Forma de Pagamento'
    fill_in 'Horário de Check-in', with: '13:00'
    fill_in 'Horário de Check-out', with: '11:00'
    fill_in 'Políticas de Uso', with: 'Boa convivência'
    check 'Está ativa?'
    click_on 'Salvar'
  
    # Assert
    expect(page).to have_content 'Pousada cadastrada com sucesso!'
    expect(page).to have_content 'Pousada das Pedras'
    expect(page).to have_content 'Descrição: Pousada para a família'
    expect(page).to have_content 'Rua das Pedras, 56, Centro, BH, MG CEP: 30000-000'
    expect(page).to have_content 'Forma de Pagamento: Pix'
    expect(page).to have_content 'Não aceita animais'
    expect(current_path).to eq '/inns/1'
  end

  it 'com dados incompletos' do
    # Arrange
  
    # Act
    visit root_path
    sign_up
    fill_in 'Nome Fantasia', with: ''
    fill_in 'Razão Social', with: ''
    click_on 'Salvar'
  
    # Assert
    expect(page).to have_content "Nome Fantasia não pode ficar em branco"
    expect(page).to have_content "Razão Social não pode ficar em branco"
    expect(page).to have_content "CNPJ não pode ficar em branco"
    expect(page).to have_content "Telefone não pode ficar em branco"
    expect(page).to have_content "E-mail não pode ficar em branco"
    expect(page).to have_content "Descrição não pode ficar em branco"
    expect(page).to have_content "Rua não pode ficar em branco"
    expect(page).to have_content "Número não pode ficar em branco"
    expect(page).to have_content "Bairro não pode ficar em branco"
    expect(page).to have_content "Cidade não pode ficar em branco"
    expect(page).to have_content "Estado não pode ficar em branco"
    expect(page).to have_content "CEP não pode ficar em branco"
    expect(page).to have_content "Horário de Check-in não pode ficar em branco"
    expect(page).to have_content "Horário de Check-out não pode ficar em branco"
    expect(page).to have_content "Políticas de Uso não pode ficar em branco"
    expect(page).to have_content 'Pousada não cadastrada.'
  end
end