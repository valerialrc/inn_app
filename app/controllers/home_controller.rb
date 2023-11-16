class HomeController < ApplicationController
  def index
    @cities = Inn.where(active: true).joins(:address).pluck('addresses.city').uniq
    @recent_inns = Inn.where(active: true).order(created_at: :desc).limit(3)
    @other_inns = Inn.where(active: true).where.not(id: @recent_inns.pluck(:id))
  end

  def show
    @city = params.require(:city).permit(:id)
    @inns = Inn.joins(:address).where(addresses: { city: @city }).order(:trade_name)
  end
end