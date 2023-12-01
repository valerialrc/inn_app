class ConsumedItemsController < ApplicationController
  before_action :authenticate_user!

  def new
    @reservation = Reservation.find(params[:reservation_id])
    @consumed_item = @reservation.consumed_items.new
  end

  def create
    @reservation = Reservation.find(params[:reservation_id])
    @consumed_item = @reservation.consumed_items.build(consumed_item_params)

    if @consumed_item.save
      redirect_to @reservation, notice: 'Item consumido adicionado com sucesso.'
    else
      flash.now[:alert] = 'Não foi possível adicionar o item consumido.'
      render :new
    end
  end

  private

  def consumed_item_params
    params.require(:consumed_item).permit(:description, :price)
  end
end
