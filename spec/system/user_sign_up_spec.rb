require 'rails_helper'

describe 'Usuário se cadastra' do
  it 'com sucesso' do
    # Arrange

    # Act
    visit root_path
    sign_up
    
    # Assert
    expect(page).to have_content 'Boas vindas! Você realizou seu registro com sucesso.'
    within('nav') do
      expect(page).to have_content 'joao@email.com'
      expect(page).to have_button 'Sair'
    end
  end
end