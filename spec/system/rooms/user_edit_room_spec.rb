require 'rails_helper'

describe 'Usuário edita um quarto' do
  it 'a partir da página de detalhes e logado' do
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

    # Act
    visit root_path
    login
    click_on('Pousada das Pedras')
    click_on('Quarto Premium')
    click_on('Editar')

    # Assert
    expect(page).to have_content('Editar Quarto')
    expect(page).to have_field('Nome', with: 'Quarto Premium')
    expect(page).to have_field('Descrição', with: 'Um quarto espaçoso e confortável')
    expect(page).to have_field('Dimensão', with: 30.5)
    expect(page).to have_field('Ocupação Máxima', with: 2)
    expect(page).to have_field('Diária', with: 200.0)
    expect(page).to have_checked_field('Banheiro próprio')
    expect(page).to have_unchecked_field('Varanda')
    expect(page).to have_checked_field('Ar-condicionado')
    expect(page).to have_checked_field('TV')
    expect(page).to have_checked_field('Guarda-roupas')
    expect(page).to have_unchecked_field('Cofre')
    expect(page).to have_checked_field('Acessível para pessoas com deficiência')
    expect(page).to have_checked_field('Disponível')
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

    # Act
    visit root_path
    login
    click_on('Pousada das Pedras')
    click_on('Quarto Premium')
    click_on('Editar')
    fill_in 'Nome', with: 'Quarto Plus'
    uncheck 'TV'
    click_on('Salvar')

    # Assert
    expect(page).to have_content('Quarto atualizado com sucesso!')
    expect(page).to have_content('Quarto Plus')
  end

  it 'e mantem os campos obrigatórios' do
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

    # Act
    visit root_path
    login
    click_on('Pousada das Pedras')
    click_on('Quarto Premium')
    click_on('Editar')
    fill_in 'Nome', with: ''
    uncheck 'TV'
    click_on('Salvar')

    # Assert
    expect(page).to have_content('Não foi possível atualizar o quarto')
  end
end