require 'rails_helper'

describe "Inn API" do
  context 'GET /api/v1/inns/1' do
    it 'success' do
      # Arrange
      user = User.create!(email: 'joao@email.com', password: 'password')

      pm = PaymentMethod.create!(name: 'Pix')

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

      # Act
      get "/api/v1/inns/#{inn.id}"

      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response["trade_name"]).to eq('Pousada das Pedras')
      expect(json_response.keys).not_to include 'created_at'
      expect(json_response.keys).not_to include 'updated_at'
      expect(json_response.keys).not_to include 'cnpj'
      expect(json_response["average_rating"]).to eq('')

    end

    it 'fail if inn not found' do
      # Arrange

      # Act
      get "/api/v1/inns/999999"

      # Assert
      expect(response.status).to eq 404
    end
  end

  context 'GET /api/v1/inns' do
    it 'success' do
      # Arrange
      user = User.create!(email: 'joao@email.com', password: 'password')

      pm = PaymentMethod.create!(name: 'Pix')

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
  
      ana = User.create!(email: 'ana@email.com', password: 'password')
  
      other_inn = Inn.new(user: ana, trade_name: 'Pousada das Cachoeiras',
                        legal_name: 'Pousada das Cachoeiras LTDA', cnpj: '987654321',
                        phone: '(31)99999-1111', email: 'contato@cachoeiras.com',
                        description: 'Pousada para a família',
                        payment_method: pm, accepts_pets: true, 
                        checkin_time: '13:00', checkout_time: '11:00',
                        policies: 'Boa convivência', active: true)
      
      other_address = other_inn.build_address(street: 'Rua das Cachoeiras', number: 56,
                                district: 'Centro', city: 'Ubá', state: 'MG',
                                cep: '30000-050', inn: other_inn)
              
      other_inn.save!
                            
      # Act
      get "/api/v1/inns"

      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Array
      expect(json_response.length).to eq 2
      expect(json_response[0]['trade_name']).to eq 'Pousada das Pedras'
      expect(json_response[1]['trade_name']).to eq 'Pousada das Cachoeiras'
      expect(json_response[0]["average_rating"]).to eq('')
      expect(json_response[0].keys).not_to include 'cnpj'
    end

    it 'return empty if there is no inn' do
      # Arrange
        
      # Act
      get "/api/v1/inns"

      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response).to eq []
    end

    it 'fail if theres an internal error' do
      # Arrange
      allow(Inn).to receive(:all).and_raise(ActiveRecord::QueryCanceled)
        
      # Act
      get "/api/v1/inns"

      # Assert
      expect(response).to have_http_status(500)
    end
  end

  context 'GET /api/v1/inns/1/rooms' do
    it 'success' do
      # Arrange
      user = User.create!(email: 'joao@email.com', password: 'password')

      pm = PaymentMethod.create!(name: 'Pix')

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

      room = Room.create!(name: 'Quarto Premium',
                        description: 'Um quarto espaçoso e confortável',
                        dimension: 30.5, max_occupancy: 2, daily_rate: 200.0,
                        has_bathroom: true, has_balcony: false,
                        has_air_conditioning: true, has_tv: true,
                        has_wardrobe: true, has_safe: false, is_accessible: true,
                        is_available:true, inn: inn)

      other_room = Room.create!(name: 'Quarto Simples',
                        description: 'Um quarto espaçoso e confortável',
                        dimension: 20, max_occupancy: 1, daily_rate: 100.0,
                        has_bathroom: true, has_balcony: false,
                        has_air_conditioning: true, has_tv: true,
                        has_wardrobe: true, has_safe: false, is_accessible: true,
                        is_available:true, inn: inn)
                            
      # Act
      get "/api/v1/inns/1/rooms"

      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Array
      expect(json_response.length).to eq 2
      expect(json_response[0]['name']).to eq 'Quarto Premium'
      expect(json_response[1]['name']).to eq 'Quarto Simples'
    end

    it 'return empty if there is no room' do
      # Arrange
      user = User.create!(email: 'joao@email.com', password: 'password')

      pm = PaymentMethod.create!(name: 'Pix')

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
        
      # Act
      get "/api/v1/inns/1/rooms"

      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response).to eq []
    end

    it 'fail if theres an internal error' do
      # Arrange
      allow(Room).to receive(:all).and_raise(ActiveRecord::QueryCanceled)
        
      # Act
      get "/api/v1/inns/1/rooms"

      # Assert
      expect(response).to have_http_status(500)
    end
  end
  
  context 'GET /api/v1/inns/1/rooms/check_availability' do
    it 'success' do
      # Arrange
      user = User.create!(email: 'joao@email.com', password: 'password')

      pm = PaymentMethod.create!(name: 'Pix')

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

      room = Room.create!(name: 'Quarto Premium',
                        description: 'Um quarto espaçoso e confortável',
                        dimension: 30.5, max_occupancy: 2, daily_rate: 200.0,
                        has_bathroom: true, has_balcony: false,
                        has_air_conditioning: true, has_tv: true,
                        has_wardrobe: true, has_safe: false, is_accessible: true,
                        is_available:true, inn: inn)

      other_room = Room.create!(name: 'Quarto Simples',
                                description: 'Um quarto espaçoso e confortável',
                                dimension: 20, max_occupancy: 1, daily_rate: 100.0,
                                has_bathroom: true, has_balcony: false,
                                has_air_conditioning: true, has_tv: true,
                                has_wardrobe: true, has_safe: false, is_accessible: true,
                                is_available:true, inn: inn)
                            
      # Act
      get "/api/v1/inns/1/rooms/1/check_availability?checkin_date=2023-12-01&checkout_date=2023-12-05&guests_number=2"

      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Hash
      expect(json_response['message']).to eq 'Quarto disponível!'
      expect(json_response['reservation_price']).to be_present
      expect(json_response['reservation_price']).to eq '800.0'
    end

    it 'return error if room is not available' do
      # Arrange
      user = User.create!(email: 'joao@email.com', password: 'password')

      pm = PaymentMethod.create!(name: 'Pix')

      inn = Inn.new(user: user, trade_name: 'Pousada das Pedras',
                        legal_name: 'Pousada das Pedras LTDA', cnpj: '123456789',
                        phone: '(31)99999-9999', email: 'contato@pedras.com',
                        description: 'Pousada para a família',
                        payment_method: pm, accepts_pets: true, 
                        checkin_time: '13:00', checkout_time: '11:00',
                        policies: 'Boa convivência', active: false)
  
      address = inn.build_address(
        street: 'Rua das Pedras',
        number: 56,
        district: 'Centro',
        city: 'BH',
        state: 'MG',
        cep: '30000-000'
      )
      
      inn.save!

      room = Room.create!(name: 'Quarto Premium',
                        description: 'Um quarto espaçoso e confortável',
                        dimension: 30.5, max_occupancy: 2, daily_rate: 200.0,
                        has_bathroom: true, has_balcony: false,
                        has_air_conditioning: true, has_tv: true,
                        has_wardrobe: true, has_safe: false, is_accessible: true,
                        is_available:true, inn: inn)
                            
      checkin_date = 1.day.from_now.in_time_zone.strftime('%Y-%m-%d')
      checkout_date = 1.week.from_now.in_time_zone.strftime('%Y-%m-%d')

      # Act
      get "/api/v1/inns/1/rooms/1/check_availability?checkin_date=#{checkin_date}&checkout_date=#{checkout_date}&guests_number=2"
                            
      # Assert
      expect(response.status).to eq 422
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Hash
      expect(json_response['error']).to eq 'Quarto não disponível para reserva.'
    end

    it 'return error if room is already reservated' do
      # Arrange
      user = User.create!(email: 'joao@email.com', password: 'password')

      pm = PaymentMethod.create!(name: 'Pix')

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

      room = Room.create!(name: 'Quarto Premium',
                          description: 'Um quarto espaçoso e confortável',
                          dimension: 30.5, max_occupancy: 2, daily_rate: 200.0,
                          has_bathroom: true, has_balcony: false,
                          has_air_conditioning: true, has_tv: true,
                          has_wardrobe: true, has_safe: false, is_accessible: true,
                          is_available:true, inn: inn)

      customer = Customer.create!(full_name: 'Carlos Silva', cpf: '11111111111',
                                  email: 'carlos@email.com', password: 'password')


      reservation = Reservation.create!(room: room, customer: customer, checkin_date: 1.day.from_now,
                                        checkout_date:1.week.from_now, guests_number: 2)

      checkin_date = 1.day.from_now.in_time_zone.strftime('%Y-%m-%d')
      checkout_date = 1.week.from_now.in_time_zone.strftime('%Y-%m-%d')

      # Act
      get "/api/v1/inns/1/rooms/1/check_availability?checkin_date=#{checkin_date}&checkout_date=#{checkout_date}&guests_number=2"
                            
      # Assert
      expect(response.status).to eq 422
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Hash
      expect(json_response['error']).to eq 'Já existe uma reserva para este quarto durante este período.'
    end

    it "return an error if guests number exceeds the limit" do
      # Arrange
      user = User.create!(email: 'joao@email.com', password: 'password')

      pm = PaymentMethod.create!(name: 'Pix')

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

      room = Room.create!(name: 'Quarto Premium',
                          description: 'Um quarto espaçoso e confortável',
                          dimension: 30.5, max_occupancy: 2, daily_rate: 200.0,
                          has_bathroom: true, has_balcony: false,
                          has_air_conditioning: true, has_tv: true,
                          has_wardrobe: true, has_safe: false, is_accessible: true,
                          is_available:true, inn: inn)

      checkin_date = 1.day.from_now.in_time_zone.strftime('%Y-%m-%d')
      checkout_date = 1.week.from_now.in_time_zone.strftime('%Y-%m-%d')

      # Act
      get "/api/v1/inns/1/rooms/1/check_availability?checkin_date=#{checkin_date}&checkout_date=#{checkout_date}&guests_number=3"
                            
      # Assert
      expect(response.status).to eq 422
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Hash
      expect(json_response['error']).to eq 'O Número de Hóspedes é maior que a capacidade do quarto.'
    end

    it 'fail if theres an internal error' do
      # Arrange
      allow_any_instance_of(Api::V1::RoomsController).to receive(:check_availability).and_raise(ActiveRecord::QueryCanceled)

      checkin_date = 1.day.from_now.in_time_zone.strftime('%Y-%m-%d')
      checkout_date = 1.week.from_now.in_time_zone.strftime('%Y-%m-%d')

      # Act
      get "/api/v1/inns/1/rooms/1/check_availability?checkin_date=#{checkin_date}&checkout_date=#{checkout_date}&guests_number=3"
             
      # Assert
      expect(response).to have_http_status(500)
    end

    it 'fail if not found' do
      # Arrange
      checkin_date = 1.day.from_now.in_time_zone.strftime('%Y-%m-%d')
      checkout_date = 1.week.from_now.in_time_zone.strftime('%Y-%m-%d')

      # Act
      get "/api/v1/inns/1/rooms/1/check_availability?checkin_date=#{checkin_date}&checkout_date=#{checkout_date}&guests_number=3"
             
      # Assert
      expect(response).to have_http_status(404)
    end
  end
end
