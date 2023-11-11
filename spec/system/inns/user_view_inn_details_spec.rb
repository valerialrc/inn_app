require 'rails_helper'

describe 'Usuário vê detalhes de um pousada' do
  it 'e vê informações adicionais' do 
    # Arrange
    create_inn

    # Act
    visit root_path
    click_on('Pousada das Pedras')

    # Assert
    expect(page).to have_content('Pousada das Pedras')
    expect(page).to have_content('Descrição: Pousada para a família')
    expect(page).to have_content('Rua das Pedras, 56, Centro, BH, MG CEP: 30000-000')
    expect(page).to have_content('Forma de Pagamento: Pix')
    expect(page).to have_content('Aceita animais')
  end

  it 'e volta para a tela inicial' do
    # Arrange
    create_inn

    # Act
    visit root_path
    click_on 'Pousada das Pedras'
    click_on 'Voltar'

      # Assert
      expect(current_path).to eq('/')
    end
end