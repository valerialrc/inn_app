def sign_up
  click_on 'Entrar'
  click_on 'Criar conta como Dono de Pousada'
  fill_in 'E-mail', with: 'joao@email.com'
  fill_in 'Senha', with: 'password'
  fill_in 'Confirme sua senha', with: 'password'
  click_on 'Criar conta'
end

def sign_up_as_customer(customer)
  click_on 'Entrar'
  click_on 'Criar conta como Cliente'
  fill_in 'Nome Completo', with: customer.full_name
  fill_in 'CPF', with: customer.cpf
  fill_in 'E-mail', with: customer.email
  fill_in 'Senha', with: customer.password
  fill_in 'Confirme sua senha', with: customer.password
  click_on 'Criar conta'
end