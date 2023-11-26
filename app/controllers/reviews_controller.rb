class ReviewsController < ApplicationController
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
    if user_signed_in?
      @reviews = current_user.inn.reviews
      @reservations = @reviews.map(&:reservation).uniq
    else
      @inn = Inn.find(params[:inn_id])
      @reviews = @inn.reviews
      @reservations = @reviews.map(&:reservation).uniq
    end
  end

  private

  def review_params
    params.require(:review).permit(:score, :description)
  end
  
end
