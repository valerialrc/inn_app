def login
  click_on 'Entrar'
  within('main form') do
    fill_in 'E-mail', with: 'joao@email.com'
    fill_in 'Senha', with: 'password'
    click_on 'Entrar'
  end
end