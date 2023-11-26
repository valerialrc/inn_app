class ActiveReservationsController < ApplicationController
  def index
    if user_signed_in?
      @reservations = current_user.inn.reservations.where(status: :active)
    elsif customer_signed_in?
      @reservations = Reservation.where(id: current_customer.reservations.active_reservations)
    else
      redirect_to root_path, alert: 'Acesso negado. Você não tem permissão para acessar esta página.'
    end
  end

  def closed
    @active_reservation = ActiveReservation.find(params[:id])
    @reservation = Reservation.find(@active_reservation.reservation_id)    

    if @active_reservation.checkout_date.nil?
      @reservation.closed!
      @active_reservation.update!(checkout_date: Time.now)

      room = @reservation.room
      date_range = (@active_reservation.checkin_date.to_date..@active_reservation.checkout_date.prev_day.to_date)
      total_price = date_range.sum { |date| room.price_on_reservation_date(date) }
  
      if @active_reservation.checkout_date.strftime('%H:%M') > room.inn.checkout_time
        total_price += room.price_on_reservation_date(@active_reservation.checkout_date.to_date)
      end
  
      @active_reservation.update!(total_price: total_price, payment_method: room.inn.payment_method.name)

      redirect_to closed_reservations_path
    end
  end
end