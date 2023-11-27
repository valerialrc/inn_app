class Api::V1::RoomsController < Api::V1::ApiController
  def index
    rooms = Room.where(inn_id: params[:inn_id])
    render status: 200, json: rooms.as_json(
      except: [:created_at, :updated_at]
    )
  end

  def check_availability
    room = Room.find(params[:id])
    reservation = room.reservations.build(reservation_params)

    if room.is_available? && room.inn.active?
      if reservation.valid?
        reservation_price = reservation.total_price
        render status: 200, json: { message: 'Quarto disponível!', reservation_price: reservation_price }
      else
        render status: 422, json: { error: reservation.errors.full_messages.first }
      end
    else
      render status: 422, json: { error: 'Quarto não disponível para reserva.' }
    end
  end

  private

  def reservation_params
    params.permit(:checkin_date, :checkout_date, :guests_number)
  end
end