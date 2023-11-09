class InnsController < ApplicationController
  before_action :set_inn, only: [:show, :edit, :update]

  def show
  end

  def new
    @inn = Inn.new
    @inn.build_address 
  end

  def create
    @inn = Inn.new(inn_params)
    @inn.user = current_user

    if @inn.save
      redirect_to @inn, notice: 'Pousada cadastrada com sucesso!'
    else
      flash.now[:notice] = 'Pousada não cadastrada.'
      render :new
    end
  end

  def edit
  end

  def update
    if @inn.update(inn_params)
      redirect_to @inn, notice: 'Pousada atualizada com sucesso!'
    else
      flash.now[:notice] = 'Não foi possível atualizar a pousada.'
      render :edit
    end
  end

  private

  def set_inn
    @inn = Inn.find(params[:id])
  end

  def inn_params
    params.require(:inn).permit(
      :trade_name, :legal_name, :cnpj, :phone, :email, :description,
      :payment_method_id, :accepts_pets, :checkin_time, :checkout_time,
      :policies, :active, address_attributes: [:id, :street, :number, :district, :state, :city, :cep]
    )
  end
end