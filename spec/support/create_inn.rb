def create_inn
  user = User.create!(email: 'joao@email.com', password: 'password')
    address = Address.create!(street: 'Rua das Pedras', number: 56,
                              district: 'Centro', city: 'BH', state: 'MG',
                              cep: '30000-000')

    pm = PaymentMethod.create!(name: 'Pix')
    pm2 = PaymentMethod.create!(name: 'Dinheiro')

    inn = Inn.create!(user: user, trade_name: 'Pousada das Pedras', cnpj: 'CNPJ',
                      phone: '(31)99999-9999', email: 'contado@pedras.com',
                      description: 'Pousada para a família', address: address,
                      payment_method: pm, accepts_pets: true, 
                      checkin_time: '13:00', checkout_time: '11:00',
                      policies: 'Boa convivência', active: true)
end