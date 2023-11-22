class ActiveReservationsController < ApplicationController
  def index
    if user_signed_in?
      @reservations = Reservation.where(id: current_user.inn.active_reservations)
    elsif customer_signed_in?
      @reservations = Reservation.where(id: current_customer.reservations.active_reservations)
    else
      redirect_to root_path, alert: 'Acesso negado. Você não tem permissão para acessar esta página.'
    end
  end
end