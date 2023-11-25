class ClosedReservationsController < ApplicationController
  def index
    @reservations = Reservation.closed
  end
end
