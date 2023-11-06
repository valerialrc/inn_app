# require 'rails_helper'

# describe 'Usuário se cadastra' do

#   it 'a partir da tela inicial' do
#     # Arrange

#     # Act
#     visit root_path
#     click_on 'Crie sua conta'

#     # Assert
#     expect(page).to have_field('Email')
#     expect(page).to have_field('Senha')
#     expect(page).to have_field('Confirme a senha')
#   end

#   it 'com sucesso' do
#     # Arrange
  
#     # Act
#     visit root_path
#     click_on 'Crie sua conta'
#     fill_in 'Email', with: 'joao@teste.com'
#     fill_in 'Senha', with: '12345'
#     fill_in 'Confirme a senha', with: '12345'
#     click_on 'Cadastrar'
  
#     # Assert
#     expect(current_path).to eq root_path
#     expect(page).to have_content 'Usuário cadastrado com sucesso!'
#   end

#   it 'com dados imcompletos' do
#     # Arrange
  
#     # Act
#     visit root_path
#     click_on 'Crie sua conta'
#     fill_in 'Email', with: ''
#     fill_in 'Senha', with: ''
#     fill_in 'Confirme a senha', with: ''
#     click_on 'Cadastrar'
  
#     # Assert
#     expect(page).to have_content 'Usuário não cadastrado.'
#   end

#   it 'com senhas divergentes' do
#     # Arrange
  
#     # Act
#     visit root_path
#     click_on 'Crie sua conta'
#     fill_in 'Email', with: '@joao@teste.com'
#     fill_in 'Senha', with: '12345'
#     fill_in 'Confirme a senha', with: '12344'
#     click_on 'Cadastrar'
  
#     # Assert
#     expect(page).to have_content 'Usuário não cadastrado. Senhas diferentes.'
#   end
# end