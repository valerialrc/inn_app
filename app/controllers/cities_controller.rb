class CitiesController < ApplicationController
  def show
    @city = params[:id]
    @inns = Inn.joins(:address).where(addresses: { city: @city }).order(:trade_name).distinct
  end
end