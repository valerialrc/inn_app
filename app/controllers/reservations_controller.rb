class ReservationsController < ApplicationController
  before_action :authenticate_customer!, only: [:confirm_reservation]
  before_action :set_room, only: [:show, :new, :create]
  before_action :check_user, only: [:new]
  
  def show
    @reservation = Reservation.find(params[:id])

    unless current_customer == @reservation.customer || current_user == @reservation.room.inn.user
      return redirect_to root_path, alert: 'Acesso negado. Você não tem permissão para acessar esta página.'
    end
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
    if user_signed_in?
      @reservations = current_user.inn.reservations
    elsif customer_signed_in?
      @reservations = current_customer.reservations
    else
      redirect_to root_path, alert: 'Acesso negado. Você não tem permissão para acessar esta página.'
    end
  end

  def canceled
    @reservation = Reservation.find(params[:id])
    if ((@reservation.created_at + 7.days).after?(Time.zone.now) && current_customer == @reservation.customer) \
       || ((@reservation.checkin_date + 2.days).before?(Time.zone.now) && current_user == @reservation.room.inn.user)
      @reservation.canceled!
      redirect_to reservations_path
    end
  end

  def active
    @reservation = Reservation.find(params[:id])
    if (@reservation.checkin_date).before?(Time.zone.now)
      @reservation.active!
      ActiveReservation.create!(reservation: @reservation, checkin_date: Time.now)
      redirect_to active_reservations_url
    else
      redirect_to reservations_path, alert: 'Você só pode fazer check-in do cliente a partir da data da reserva.'
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

  def check_user
    if user_signed_in?
      redirect_to root_path, alert: 'Acesso negado. Você não tem permissão para acessar esta página.'
    end
  end
end
