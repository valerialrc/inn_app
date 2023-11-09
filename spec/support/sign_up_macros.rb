def sign_up
  click_on 'Entrar'
  click_on 'Criar conta como Dono de Pousada'
  fill_in 'E-mail', with: 'joao@email.com'
  fill_in 'Senha', with: 'password'
  fill_in 'Confirme sua senha', with: 'password'
  click_on 'Criar conta'
end