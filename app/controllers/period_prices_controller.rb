class PeriodPricesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room
  before_action :set_inn

  def new
    @period_price = @room.period_prices.build
  end

  def create
    @period_price = @room.period_prices.build(period_price_params)

    if @period_price.save
      redirect_to inn_room_path(@inn, @room), notice: 'Preço personalizado cadastrado com sucesso!'
    else
      flash.now[:notice] = 'Preço por período não cadastrado.'
      render :new
    end
  end

  private

  def set_room
    @room = current_user.inn.rooms.find(params[:room_id])
  end

  def set_inn
    @inn = current_user.inn
  end

  def period_price_params
    params.require(:period_price).permit(:start_date, :end_date, :daily_value)
  end
end
