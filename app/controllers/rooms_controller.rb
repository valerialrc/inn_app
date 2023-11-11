class RoomsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]
  before_action :set_room, only: [:show, :edit, :update]
  before_action :set_inn, only: [:show, :new, :create, :edit, :update]
  skip_before_action :check_for_inn, only: [:new, :create, :edit, :update]

  def show
  end

  def new
    @room = @inn.rooms.build
  end

  def create
    @room = @inn.rooms.build(room_params)

    if @room.save
      redirect_to @inn, notice: 'Quarto cadastrado com sucesso!'
    else
      flash.now[:notice] = 'Quarto não cadastrado.'
      render :new
    end
  end

  def edit
    redirect_to root_path,
    notice: "Você não tem permissão para editar este quarto." unless
    current_user == @inn.user
  end

  def update
    redirect_to root_path,
    notice: "Você não tem permissão para editar este quarto." unless
    current_user == @inn.user

    if @room.update(room_params)
      redirect_to @inn, notice: 'Quarto atualizado com sucesso!'
    else
      flash.now[:notice] = 'Não foi possível atualizar o quarto.'
      render :edit
    end
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end

  def set_inn
    @inn = Inn.find(params[:inn_id])
  end

  def room_params
    params.require(:room).permit(
      :name, :description, :dimension, :max_occupancy, :daily_rate, :has_bathroom,
      :has_balcony, :has_air_conditioning, :has_tv, :has_wardrobe, :has_safe,
      :is_accessible, :is_available
    )
  end
end
