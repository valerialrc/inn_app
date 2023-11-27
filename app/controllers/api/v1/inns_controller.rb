class Api::V1::InnsController < Api::V1::ApiController

  def show
    inn = Inn.find(params[:id])
    render status: 200, json: inn.as_json(except: [:created_at, :updated_at],
      include: {
        address: { except: [:created_at, :updated_at] }
      }
    )
  end

  def index
    inns = Inn.all.includes(:address)
    render status: 200, json: inns.as_json(
      except: [:created_at, :updated_at],
      include: {
        address: { except: [:created_at, :updated_at] }
      }
    )
  end

  def create
    inn_params = params.require(:inn).permit(:user_id, :trade_name, :legal_name, :cnpj,
                                             :phone, :email, :description,
                                             :payment_method_id, :accepts_pets,
                                             :checkin_time, :checkout_time,
                                             :policies, :active,
                                              address_attributes: [:id, :street,
                                             :number, :district, :state, :city, :cep])
                                                                                
    inn = Inn.new(inn_params)

    if inn.save
      render status: 201, json: inn.as_json(
        except: [:created_at, :updated_at],
        include: {
          address: { except: [:created_at, :updated_at] }
        }
      )
    else
      render status: 412, json: { errors: inn.errors.full_messages, address_errors: inn.address&.errors&.full_messages }

    end
  end

  private

  def return_500
    render status: 500
  end

  def return_404
    render status: 404
  end
end