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

  it 'e deve cadastrar pousada antes de visualizar qualquer outra página' do
    # Arrange

    # Act
    visit root_path
    sign_up
    visit root_path

    # Assert
    expect(page).to have_content 'Você precisa cadastrar uma pousada antes de continuar.'
    within('nav') do
      expect(page).not_to have_link 'Entrar'
      expect(page).to have_button 'Sair'
      expect(page).to have_content 'joao@email.com'
    end
  end
end