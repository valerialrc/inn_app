def create_inn
  user = User.create!(email: 'joao@email.com', password: 'password')

  pm = PaymentMethod.create!(name: 'Pix')
  pm2 = PaymentMethod.create!(name: 'Dinheiro')

  inn = Inn.new(user: user, trade_name: 'Pousada das Pedras',
                legal_name: 'Pousada das Pedras LTDA', cnpj: '123456789',
                phone: '(31)99999-9999', email: 'contato@pedras.com',
                description: 'Pousada para a família',
                payment_method: pm, accepts_pets: true, 
                checkin_time: '13:00', checkout_time: '11:00',
                policies: 'Boa convivência', active: true)

  address = inn.build_address(
    street: 'Rua das Pedras',
    number: 56,
    district: 'Centro',
    city: 'BH',
    state: 'MG',
    cep: '30000-000'
  )
  
  inn.save!
end