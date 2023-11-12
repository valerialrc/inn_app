require 'rails_helper'

describe 'Usuário verifica preços por período' do
  it 'na página de detalhes de um quarto e não ha nenhum cadastrado' do 
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
    click_on('Pousada das Pedras')
    click_on('Quarto Premium')

    # Assert
    expect(page).to have_content('Preços Personalizados')
    expect(page).to have_content('Nenhum preço personalizado cadastrado.')
  end

  it 'na página de detalhes de um quarto e há preços cadastrados' do 
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

    p = PeriodPrice.create!(room: room, start_date: '2023-01-01',
                            end_date: '2023-01-07', daily_value: 150.00)
    # Act
    visit root_path
    click_on('Pousada das Pedras')
    click_on('Quarto Premium')

    # Assert
    expect(page).to have_content('Preços Personalizados')
    expect(page).to have_content('01/01/2023 - 07/01/2023: R$ 150,00')
  end
end