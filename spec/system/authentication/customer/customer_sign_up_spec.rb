require 'rails_helper'

describe 'Cliente se cadastra' do
  it 'com sucesso' do
    # Arrange
    customer = Customer.new(full_name: 'João Silva', cpf: '11111111111',
                            email: 'joao@email.com', password: 'password')

    # Act
    visit root_path
    click_on 'Entrar'
    click_on 'Criar conta como Cliente'
    fill_in 'Nome Completo', with: customer.full_name
    fill_in 'CPF', with: customer.cpf
    fill_in 'E-mail', with: customer.email
    fill_in 'Senha', with: customer.password
    fill_in 'Confirme sua senha', with: customer.password
    click_on 'Criar conta'
    
    # Assert
    expect(page).to have_content 'Boas vindas! Você realizou seu registro com sucesso.'
    within('nav') do
      expect(page).to have_content 'joao@email.com'
      expect(page).to have_button 'Sair'
    end
  end
end