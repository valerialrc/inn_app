require 'rails_helper'

describe 'Usuário cadastra um quarto de pousada' do
  it 'a partir da tela de detalhes da pousada' do
    # Arrange
    create_inn
    owner = User.first

    # Act
    login_as(owner, :scope => :user)
    visit root_path
    click_on('Pousada das Pedras')
    click_on('Cadastrar Quarto')
    
    # Assert
    expect(page).to have_content('Novo Quarto')
    expect(page).to have_field('Nome')
    expect(page).to have_field('Descrição')
    expect(page).to have_field('Dimensão')
    expect(page).to have_field('Ocupação Máxima')
    expect(page).to have_field('Diária')
    expect(page).to have_field('Banheiro próprio')
    expect(page).to have_field('Varanda')
    expect(page).to have_field('Ar-condicionado')
    expect(page).to have_field('TV')
    expect(page).to have_field('Guarda-roupas')
    expect(page).to have_field('Cofre')
    expect(page).to have_field('Acessível para pessoas com deficiência')
    expect(page).to have_field('Disponível')
  end

  it 'com sucesso' do
    # Arrange
    create_inn
    owner = User.first

    # Act
    login_as(owner, :scope => :user)
    visit root_path
    click_on('Pousada das Pedras')
    click_on('Cadastrar Quarto')
    fill_in 'Nome', with: 'Quarto Premium'
    fill_in 'Descrição', with: 'Um quarto espaçoso e confortável'
    fill_in 'Dimensão', with: '30.5'
    fill_in 'Ocupação Máxima', with: '2'
    fill_in 'Diária', with: '200.0'
    check 'Banheiro próprio'
    check 'Ar-condicionado'
    check 'TV'
    check 'Guarda-roupas'
    check 'Acessível para pessoas com deficiência'
    check 'Disponível'
    click_on 'Salvar'
  
    # Assert
    expect(page).to have_content 'Quarto cadastrado com sucesso!'
    expect(page).to have_link 'Quarto Premium'
    expect(page).to have_content 'Quartos Cadastrados'
    expect(page).to have_content 'Disponíveis'
    expect(current_path).to eq '/inns/1'
  end

  it 'com dados incompletos' do
    # Arrange
    create_inn
    owner = User.first

    # Act
    login_as(owner, :scope => :user)
    visit root_path
    click_on('Pousada das Pedras')
    click_on('Cadastrar Quarto')
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    check 'Banheiro próprio'
    check 'Ar-condicionado'
    check 'TV'
    check 'Guarda-roupas'
    check 'Acessível para pessoas com deficiência'
    check 'Disponível'
    click_on 'Salvar'
  
    # Assert
    expect(page).to have_content "Nome não pode ficar em branco"
    expect(page).to have_content "Descrição não pode ficar em branco"
    expect(page).to have_content "Dimensão não pode ficar em branco"
    expect(page).to have_content "Ocupação Máxima não pode ficar em branco"
    expect(page).to have_content "Diária não pode ficar em branco"
    expect(page).to have_content 'Quarto não cadastrado.'
  end
end