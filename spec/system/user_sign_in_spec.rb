require 'rails_helper'

describe 'Usuário se autentica' do
  it 'com sucesso' do
    # Arrange
    User.create!(email: 'joao@email.com', password: 'password')

    # Act
    visit root_path
    login

    # Assert
    expect(page).to have_content 'Login efetuado com sucesso.'
    within('nav') do
      expect(page).not_to have_link 'Entrar'
      expect(page).to have_button 'Sair'
      expect(page).to have_content 'joao@email.com'
    end
  end

  it 'e deve cadastrar pousada antes de visualizar qualquer outra página' do
    # Arrange
    User.create!(email: 'joao@email.com', password: 'password')

    # Act
    visit root_path
    login
    visit root_path

    # Assert
    expect(page).to have_content 'Você precisa cadastrar uma pousada antes de continuar.'
    within('nav') do
      expect(page).not_to have_link 'Entrar'
      expect(page).to have_button 'Sair'
      expect(page).to have_content 'joao@email.com'
    end
  end

  it 'e faz logout' do
    # Arrange
    User.create!(email: 'joao@email.com', password: 'password')

    # Act
    visit root_path
    click_on 'Entrar'
    within('form') do
      fill_in 'E-mail', with: 'joao@email.com'
      fill_in 'Senha', with: 'password'
      click_on 'Entrar'
    end
    click_on 'Sair'

    # Assert
    expect(page).to have_content 'Logout efetuado com sucesso.'
    within('nav') do
      expect(page).to have_link 'Entrar'
      expect(page).not_to have_button 'Sair'
      expect(page).not_to have_content 'joao@email.com'
    end
  end
end