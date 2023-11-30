class Api::V1::CitiesController < Api::V1::ApiController
  def index
    cities = City.all
    render status: 200, json: cities.as_json(except: [:created_at, :updated_at])
  end

  def show
    city = City.find(params[:id])
    inns = Inn.joins(:address).where(addresses: { city: city.name }, active: true).order(:trade_name).distinct

    render status: 200, json: inns.as_json(except: [:cnpj, :legal_name, :created_at, :updated_at],
      include: {
        address: { except: [:created_at, :updated_at, :inn_id] }
      },
      methods: [:average_rating]
    )
  end
end

