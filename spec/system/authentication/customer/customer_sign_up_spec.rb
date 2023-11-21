require 'rails_helper'

describe 'Cliente se cadastra' do
  it 'com sucesso' do
    # Arrange
    customer = Customer.new(full_name: 'João Silva', cpf: '11111111111',
                            email: 'joao@email.com', password: 'password')

    # Act
    visit root_path
    sign_up_as_customer(customer)
    
    # Assert
    expect(page).to have_content 'Boas vindas! Você realizou seu registro com sucesso.'
    within('nav') do
      expect(page).to have_content 'joao@email.com'
      expect(page).to have_button 'Sair'
    end
  end
end