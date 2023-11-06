require 'rails_helper'

describe 'Usuário se cadastra' do
  it 'com sucesso' do
    # Arrange

    # Act
    visit root_path
    click_on 'Entrar'
    click_on 'Criar conta'
    fill_in 'E-mail', with: 'joao@email.com'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Criar conta'
    
    # Assert
    expect(page).to have_content 'Boas vindas! Você realizou seu registro com sucesso.'
    within('nav') do
      expect(page).to have_content 'joao@email.com'
      expect(page).to have_button 'Sair'
    end
  end
end