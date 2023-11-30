require 'rails_helper'

describe 'Usuário cadastra preço por período' do
  it 'a partir da tela de detalhes do quarto' do
    # Arrange
    create_inn
    inn = Inn.find(1)

    room = Room.create!(name: 'Quarto Premium',
                        description: 'Um quarto espaçoso e confortável',
                        dimension: 30.5, max_occupancy: 2, daily_rate: 200.0,
                        has_bathroom: true, has_balcony: false,
                        has_air_conditioning: true, has_tv: true,
                        has_wardrobe: true, has_safe: false, is_accessible: true,
                        is_available:true, inn: inn)

    owner = User.first

    # Act
    login_as(owner, :scope => :user)
    visit root_path
    click_on('Pousada das Pedras')
    click_on('Quarto Premium')
    click_on('Cadastrar Novo Preço')
    
    # Assert
    expect(page).to have_content('Novo Preço Personalizado')
    expect(page).to have_field('Data Inicial')
    expect(page).to have_field('Data Final')
    expect(page).to have_field('Diária')
  end

  it 'com sucesso' do
    # Arrange
    create_inn
    inn = Inn.find(1)

    room = Room.create!(name: 'Quarto Premium',
                        description: 'Um quarto espaçoso e confortável',
                        dimension: 30.5, max_occupancy: 2, daily_rate: 200.0,
                        has_bathroom: true, has_balcony: false,
                        has_air_conditioning: true, has_tv: true,
                        has_wardrobe: true, has_safe: false, is_accessible: true,
                        is_available:true, inn: inn)

    owner = User.first

    # Act
    login_as(owner, :scope => :user)
    visit root_path
    click_on('Pousada das Pedras')
    click_on('Quarto Premium')
    click_on('Cadastrar Novo Preço')
    fill_in 'Data Inicial', with: '2023-01-01'
    fill_in 'Data Final', with: '2023-01-07'
    fill_in 'Diária', with: 150
    click_on 'Salvar'
  
    # Assert
    expect(page).to have_content 'Preço personalizado cadastrado com sucesso!'
    expect(page).to have_content 'Quarto Premium'
    expect(page).to have_content '01/01/2023 - 07/01/2023: R$ 150,00'
  end

  it 'com dados incompletos' do
    # Arrange
    create_inn
    inn = Inn.find(1)

    room = Room.create!(name: 'Quarto Premium',
                        description: 'Um quarto espaçoso e confortável',
                        dimension: 30.5, max_occupancy: 2, daily_rate: 200.0,
                        has_bathroom: true, has_balcony: false,
                        has_air_conditioning: true, has_tv: true,
                        has_wardrobe: true, has_safe: false, is_accessible: true,
                        is_available:true, inn: inn)

    owner = User.first

    # Act
    login_as(owner, :scope => :user)
    visit root_path
    click_on('Pousada das Pedras')
    click_on('Quarto Premium')
    click_on('Cadastrar Novo Preço')
    fill_in 'Data Inicial', with: ''
    fill_in 'Data Final', with: ''
    fill_in 'Diária', with: ''
    click_on 'Salvar'
  
    # Assert
    expect(page).to have_content "Data Inicial não pode ficar em branco"
    expect(page).to have_content "Data Final não pode ficar em branco"
    expect(page).to have_content "Diária não pode ficar em branco"
    expect(page).to have_content 'Preço por período não cadastrado.'
  end
end