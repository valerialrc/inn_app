class Api::V1::InnsController < Api::V1::ApiController
  def show
    inn = Inn.find(params[:id])
    render status: 200, json: inn.as_json(except: [:cnpj, :legal_name, :created_at, :updated_at],
      include: {
        address: { except: [:created_at, :updated_at] }
      },
      methods: [:average_rating]
    )
  end

  def index
    query = params.permit(:query)[:query]
    if query.present?
      inns = Inn.where("LOWER(trade_name) LIKE ?", "%#{query.downcase}%").includes(:address)
    else
      inns = Inn.all.includes(:address)
    end

    render status: 200, json: inns.as_json(
      except: [:cnpj, :legal_name, :created_at, :updated_at],
      include: {
        address: { except: [:created_at, :updated_at] }
      },
      methods: [:average_rating]
    )
  end
end