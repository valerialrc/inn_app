class ReservationsController < ApplicationController
  before_action :authenticate_customer!, only: [:confirm_reservation]
  before_action :set_room, only: [:show, :new, :create]
  
  def show
    @reservation = Reservation.find(params[:id])
  end

  def new
    @reservation = @room.reservations.build(customer: current_customer)
  end

  def create
    @reservation = @room.reservations.build(reservation_params)

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
    @reservation.customer = current_customer

    if @reservation.save
      @reservation.confirmed!
      session[:reservation_details] = nil
      
      redirect_to inn_room_reservation_path(@room.inn, @room, @reservation), notice: 'Reserva confirmada com sucesso!'
    else
      flash[:alert] = 'Reserva não efetuada.'
      redirect_to new_inn_room_reservation_path(inn_id: @room.inn.id, room_id: @room.id)
    end
  end

  def index
    @reservations = current_customer.reservations
  end

  def canceled
    @reservation = Reservation.find(params[:id])
    if (@reservation.created_at + 7.days).after?(Time.zone.now)
      @reservation.canceled!
      redirect_to reservations_path
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