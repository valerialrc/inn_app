require 'rails_helper'

RSpec.describe Inn, type: :model do
  describe '#valid?' do
    it 'apenas uma pousada para cada dono' do
      # Arrange
      user = User.create!(email: 'joao@email.com', password: 'password')

      pm = PaymentMethod.create!(name: 'Pix')
      pm2 = PaymentMethod.create!(name: 'Dinheiro')
    
      inn = Inn.create!(user: user, trade_name: 'Pousada das Pedras',
                        legal_name: 'Pousada das Pedras LTDA', cnpj: '123456789',
                        phone: '(31)99999-9999', email: 'contato@pedras.com',
                        description: 'Pousada para a família',
                        payment_method: pm, accepts_pets: true, 
                        checkin_time: '13:00', checkout_time: '11:00',
                        policies: 'Boa convivência', active: true)
      
      address = Address.create!(street: 'Rua das Pedras', number: 56,
                                district: 'Centro', city: 'BH', state: 'MG',
                                cep: '30000-000', inn: inn)

      other_inn = Inn.new(user: user, trade_name: 'Pousada das Cachoeiras',
                              legal_name: 'Pousada das Cachoeiras LTDA', cnpj: '987654321',
                              phone: '(31)99999-1111', email: 'contato@cachoeiras.com',
                              description: 'Pousada para a família',
                              payment_method: pm2, accepts_pets: true, 
                              checkin_time: '13:00', checkout_time: '11:00',
                              policies: 'Boa convivência', active: true)

      # Act
      other_inn.valid?
      result = other_inn.errors.include?(:user_id)

      # Assert
      expect(result).to be true
      expect(other_inn.errors[:user_id]).to include "já está em uso"
    end
  end
end
