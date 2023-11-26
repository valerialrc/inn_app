class InnsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]
  before_action :set_inn, only: [:show, :edit, :update]
  skip_before_action :check_for_inn, only: [:new, :create, :edit, :update]

  def show
    @last_reviews = @inn.reviews.last(3)
  end

  def new
    @inn = Inn.new
    @inn.build_address
  end

  def create
    @inn = current_user.build_inn(inn_params)
    
    if @inn.save
      redirect_to @inn, notice: 'Pousada cadastrada com sucesso!'
    else
      flash.now[:notice] = 'Pousada não cadastrada.'
      render :new
    end
  end

  def edit
    redirect_to root_path,
    notice: "Você não tem permissão para editar esta pousada." unless
    current_user == @inn.user
    
  end

  def update
    redirect_to root_path,
    notice: "Você não tem permissão para editar esta pousada." unless
    current_user == @inn.user

    if @inn.update(inn_params)
      redirect_to @inn, notice: 'Pousada atualizada com sucesso!'
    else
      flash.now[:notice] = 'Não foi possível atualizar a pousada.'
      render :edit
    end
  end

  def search
    @look_for = params[:query]

    @inns = Inn.joins(:address).where("inns.trade_name LIKE ? OR addresses.city LIKE ? OR addresses.district LIKE ?",
                                    "%#{@look_for}%", "%#{@look_for}%", "%#{@look_for}%").order(:trade_name).distinct
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