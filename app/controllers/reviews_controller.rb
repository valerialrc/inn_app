class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  def new
    @reservation = Reservation.find(params[:reservation_id])
    @review = @reservation.build_review
  end

  def create
    @reservation = Reservation.find(params[:reservation_id])
    @review = @reservation.build_review(review_params)

    if @review.save
      redirect_to @reservation, notice: 'Avaliação enviada com sucesso.'
    else
      flash.now[:notice] = 'Avaliação não enviada.'
      render :new
    end
  end

  def index
    @reviews = current_user.inn.rooms.includes(reservations: :review).map { |room| room.reservations.map(&:review) }.flatten.compact
    @reservations = @reviews.flat_map { |review| review.reservation }
  end

  private

  def review_params
    params.require(:review).permit(:score, :description)
  end
  
end
