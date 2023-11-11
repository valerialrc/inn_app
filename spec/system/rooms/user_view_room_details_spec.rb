require 'rails_helper'

describe 'Usuário verifica detalhes de um quarto' do
  it 'e vê informações adicionais' do 
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

    # Assert
    expect(page).to have_content('Um quarto espaçoso e confortável')
    expect(page).to have_content('Dimensão: 30.5 m²')
    expect(page).to have_content('Ocupação Máxima: 2')
    expect(page).to have_content('Diária: R$ 200,00')
    expect(page).to have_content('Comodidades:')
    expect(page).to have_content('Banheiro próprio Sem varanda')
    expect(page).to have_content('Ar-condicionado TV Guarda-roupas Sem cofre')
    expect(page).to have_content('Acessível para pessoas com deficiência')
  end
end