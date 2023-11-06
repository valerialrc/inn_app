class InnsController < ApplicationController 
  def show
    @inns = Inns.find(params[:id])
  end

  def new
    @inns = Inns.new
  end
  
  def create
    inns_params = params.require(:inns).permit(:trade_name, :cnpj, :phone,
    :description, :address_id, :payment_methods_id, :accepts_pets,
    :checkin_time, :checkout_time, :policies, :active)
    
    @inns = Inns.new(inns_params)
    
    if @inns.save()
      redirect_to root_path, notice: 'Pousada cadastrada com sucesso!'
    else
      flash.now[:notice] = 'Pousada não cadastrada.'
      render 'new'
    end

  end
end