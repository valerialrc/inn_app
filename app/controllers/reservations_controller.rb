class ReservationsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :set_room, only: [:show, :new, :create]
  
  def show
    @reservation = Reservation.find(params[:id])
  end

  def new
    @reservation = @room.reservations.build(user: current_user)
  end

  def create
    @reservation = @room.reservations.build(reservation_params)
    @reservation.user = current_user

    if @reservation.valid?
      check_availability
    else
      flash[:error] = 'Não foi possível concluir a reserva.'
      render :new
    end
  end

  def confirm_reservation
    @reservation = Reservation.new(session[:reservation_details])
    @room = @reservation.room

    if @reservation.save
      @reservation.confirmed!
      session[:reservation_details] = nil
      
      redirect_to inn_room_reservation_path(@room.inn, @room, @reservation), notice: 'Reserva confirmada com sucesso!'
    else
      flash[:alert] = 'Reserva não efetuada.'
      redirect_to new_inn_room_reservation_path(inn_id: @room.inn.id, room_id: @room.id)
    end
  end

  private

  def check_availability
    if @room.available_for_reservation?(@reservation)
      session[:reservation_details] = @reservation.attributes

      render :confirm_reservation
    else
      render :new
    end
  end

  def set_room
    @room = Room.find(params[:room_id])
  end

  def reservation_params
    params.require(:reservation).permit(:checkin_date, :checkout_date, :guests_number)
  end
end
