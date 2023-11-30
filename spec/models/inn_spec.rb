require 'rails_helper'

RSpec.describe Inn, type: :model do
  describe '#valid?' do
    context "presence" do
      it 'uniqueness of user_id' do
        # Arrange
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
  
        other_inn = Inn.new(user: user, trade_name: 'Pousada das Cachoeiras',
                          legal_name: 'Pousada das Cachoeiras LTDA', cnpj: '987654321',
                          phone: '(31)99999-1111', email: 'contato@cachoeiras.com',
                          description: 'Pousada para a família',
                          payment_method: pm, accepts_pets: true, 
                          checkin_time: '13:00', checkout_time: '11:00',
                          policies: 'Boa convivência', active: true)
        
        other_address = other_inn.build_address(street: 'Rua das Cachoeiras', number: 42,
                                                district: 'Centro', city: 'BH', state: 'MG',
                                                cep: '30000-050', inn: other_inn)
                  
  
        # Act
        other_inn.valid?
        result = other_inn.errors.include?(:user_id)
  
        # Assert
        expect(result).to be true
        expect(other_inn.errors[:user_id]).to include "já está em uso"
      end
  
      it 'false when user is empty' do
        # Arrange
        pm = PaymentMethod.create!(name: 'Pix')
        pm2 = PaymentMethod.create!(name: 'Dinheiro')
      
        inn = Inn.new(user_id: '', trade_name: 'Pousada das Pedras',
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
                        
        # Act
        inn.valid?
        result = inn.errors.include?(:user_id)
  
        # Assert
        expect(result).to be true
        expect(inn.errors[:user_id]).to include "não pode ficar em branco"
      end
  
      it 'false when trade_name is empty' do
        # Arrange
        user = User.create!(email: 'joao@email.com', password: 'password')
        pm = PaymentMethod.create!(name: 'Pix')
        pm2 = PaymentMethod.create!(name: 'Dinheiro')
      
        inn = Inn.new(user: user, trade_name: '',
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
                        
        # Act
        inn.valid?
        result = inn.errors.include?(:trade_name)
  
        # Assert
        expect(result).to be true
        expect(inn.errors[:trade_name]).to include "não pode ficar em branco"
        expect(inn.errors.count).to eq 1
      end
  
      it 'false when legal_name is empty' do
        # Arrange
        user = User.create!(email: 'joao@email.com', password: 'password')
        pm = PaymentMethod.create!(name: 'Pix')
        pm2 = PaymentMethod.create!(name: 'Dinheiro')
      
        inn = Inn.new(user: user, trade_name: 'Pousada das Pedras',
                      legal_name: '', cnpj: '123456789',
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
      
        # Act
        inn.valid?
        result = inn.errors.include?(:legal_name)
      
        # Assert
        expect(result).to be true
        expect(inn.errors[:legal_name]).to include "não pode ficar em branco"
        expect(inn.errors.count).to eq 1
      end
  
      it 'false when cnpj is empty' do
        # Arrange
        user = User.create!(email: 'joao@email.com', password: 'password')
        pm = PaymentMethod.create!(name: 'Pix')
        pm2 = PaymentMethod.create!(name: 'Dinheiro')
      
        inn = Inn.new(user: user, trade_name: 'Pousada das Pedras',
                      legal_name: 'Pousada das Pedras LTDA', cnpj: '',
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
      
        # Act
        inn.valid?
        result = inn.errors.include?(:cnpj)
      
        # Assert
        expect(result).to be true
        expect(inn.errors[:cnpj]).to include "não pode ficar em branco"
        expect(inn.errors.count).to eq 1
      end
  
      it 'false when phone is empty' do
        # Arrange
        user = User.create!(email: 'joao@email.com', password: 'password')
        pm = PaymentMethod.create!(name: 'Pix')
        pm2 = PaymentMethod.create!(name: 'Dinheiro')
      
        inn = Inn.new(user: user, trade_name: 'Pousada das Pedras',
                      legal_name: 'Pousada das Pedras LTDA', cnpj: '123456789',
                      phone: '', email: 'contato@pedras.com',
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
      
        # Act
        inn.valid?
        result = inn.errors.include?(:phone)
      
        # Assert
        expect(result).to be true
        expect(inn.errors[:phone]).to include "não pode ficar em branco"
        expect(inn.errors.count).to eq 1
      end
  
      it 'false when email is empty' do
        # Arrange
        user = User.create!(email: 'joao@email.com', password: 'password')
        pm = PaymentMethod.create!(name: 'Pix')
        pm2 = PaymentMethod.create!(name: 'Dinheiro')
      
        inn = Inn.new(user: user, trade_name: 'Pousada das Pedras',
                      legal_name: 'Pousada das Pedras LTDA', cnpj: '123456789',
                      phone: '(31)99999-9999', email: '',
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
      
        # Act
        inn.valid?
        result = inn.errors.include?(:email)
      
        # Assert
        expect(result).to be true
        expect(inn.errors[:email]).to include "não pode ficar em branco"
        expect(inn.errors.count).to eq 1
      end
  
      it 'false when description is empty' do
        # Arrange
        user = User.create!(email: 'joao@email.com', password: 'password')
        pm = PaymentMethod.create!(name: 'Pix')
        pm2 = PaymentMethod.create!(name: 'Dinheiro')
      
        inn = Inn.new(user: user, trade_name: 'Pousada das Pedras',
                      legal_name: 'Pousada das Pedras LTDA', cnpj: '123456789',
                      phone: '(31)99999-9999', email: 'contato@pedras.com',
                      description: '', payment_method: pm, accepts_pets: true,
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
      
        # Act
        inn.valid?
        result = inn.errors.include?(:description)
      
        # Assert
        expect(result).to be true
        expect(inn.errors[:description]).to include "não pode ficar em branco"
        expect(inn.errors.count).to eq 1
      end
  
      it 'false when checkin_time is empty' do
        # Arrange
        user = User.create!(email: 'joao@email.com', password: 'password')
        pm = PaymentMethod.create!(name: 'Pix')
        pm2 = PaymentMethod.create!(name: 'Dinheiro')
      
        inn = Inn.new(user: user, trade_name: 'Pousada das Pedras',
                      legal_name: 'Pousada das Pedras LTDA', cnpj: '123456789',
                      phone: '(31)99999-9999', email: 'contato@pedras.com',
                      description: 'Pousada para a família',
                      payment_method: pm, accepts_pets: true,
                      checkin_time: '', checkout_time: '11:00',
                      policies: 'Boa convivência', active: true)
      
        address = inn.build_address(
          street: 'Rua das Pedras',
          number: 56,
          district: 'Centro',
          city: 'BH',
          state: 'MG',
          cep: '30000-000'
        )
      
        # Act
        inn.valid?
        result = inn.errors.include?(:checkin_time)
      
        # Assert
        expect(result).to be true
        expect(inn.errors[:checkin_time]).to include "não pode ficar em branco"
        expect(inn.errors.count).to eq 1
      end
  
      it 'false when checkout_time is empty' do
        # Arrange
        user = User.create!(email: 'joao@email.com', password: 'password')
        pm = PaymentMethod.create!(name: 'Pix')
        pm2 = PaymentMethod.create!(name: 'Dinheiro')
      
        inn = Inn.new(user: user, trade_name: 'Pousada das Pedras',
                      legal_name: 'Pousada das Pedras LTDA', cnpj: '123456789',
                      phone: '(31)99999-9999', email: 'contato@pedras.com',
                      description: 'Pousada para a família',
                      payment_method: pm, accepts_pets: true,
                      checkin_time: '13:00', checkout_time: '',
                      policies: 'Boa convivência', active: true)
      
        address = inn.build_address(
          street: 'Rua das Pedras',
          number: 56,
          district: 'Centro',
          city: 'BH',
          state: 'MG',
          cep: '30000-000'
        )
      
        # Act
        inn.valid?
        result = inn.errors.include?(:checkout_time)
      
        # Assert
        expect(result).to be true
        expect(inn.errors[:checkout_time]).to include "não pode ficar em branco"
        expect(inn.errors.count).to eq 1
      end
  
      it 'false when policies is empty' do
        # Arrange
        user = User.create!(email: 'joao@email.com', password: 'password')
        pm = PaymentMethod.create!(name: 'Pix')
        pm2 = PaymentMethod.create!(name: 'Dinheiro')
      
        inn = Inn.new(user: user, trade_name: 'Pousada das Pedras',
                      legal_name: 'Pousada das Pedras LTDA', cnpj: '123456789',
                      phone: '(31)99999-9999', email: 'contato@pedras.com',
                      description: 'Pousada para a família',
                      payment_method: pm, accepts_pets: true,
                      checkin_time: '13:00', checkout_time: '11:00',
                      policies: '', active: true)
      
        address = inn.build_address(
          street: 'Rua das Pedras',
          number: 56,
          district: 'Centro',
          city: 'BH',
          state: 'MG',
          cep: '30000-000'
        )
      
        # Act
        inn.valid?
        result = inn.errors.include?(:policies)
      
        # Assert
        expect(result).to be true
        expect(inn.errors[:policies]).to include "não pode ficar em branco"
        expect(inn.errors.count).to eq 1
      end
  
      it 'false when payment_method is empty' do
        # Arrange
        user = User.create!(email: 'joao@email.com', password: 'password')
      
        inn = Inn.new(user: user, trade_name: 'Pousada das Pedras',
                      legal_name: 'Pousada das Pedras LTDA', cnpj: '123456789',
                      phone: '(31)99999-9999', email: 'contato@pedras.com',
                      description: 'Pousada para a família',
                      accepts_pets: true,
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
      
        # Act
        inn.valid?
        result = inn.errors.include?(:payment_method)
      
        # Assert
        expect(result).to be true
        expect(inn.errors[:payment_method]).to include "é obrigatório(a)"
        expect(inn.errors[:payment_method_id]).to include "não pode ficar em branco"
        expect(inn.errors.count).to eq 2
      end    
    end
  end
end
