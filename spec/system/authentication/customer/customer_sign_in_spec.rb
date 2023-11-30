require 'rails_helper'

describe 'Cliente se autentica' do
  it 'com sucesso' do
    # Arrange
    customer = Customer.create!(full_name: 'João Silva', cpf: '11111111111',
                                email: 'joao@email.com', password: 'password')

    # Act
    visit root_path
    click_on 'Entrar'
    within('main form') do
      fill_in 'E-mail', with: 'joao@email.com'
      fill_in 'Senha', with: 'password'
      click_on 'Entrar'
    end
    
    # Assert
    expect(page).to have_content 'Login efetuado com sucesso.'
    within('nav') do
      expect(page).not_to have_link 'Entrar'
      expect(page).to have_button 'Sair'
      expect(page).to have_content 'joao@email.com'
    end
  end


  it 'e faz logout' do
    # Arrange
    customer = Customer.create!(full_name: 'João Silva', cpf: '11111111111',
                                email: 'joao@email.com', password: 'password')

    # Act
    login_as(customer, :scope => :customer)
    visit root_path
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