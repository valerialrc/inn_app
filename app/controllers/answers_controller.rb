class AnswersController < ApplicationController
  before_action :authenticate_user!

  def new
    @review = Review.find(params[:review_id])
    @answer = @review.build_answer
    @answer.user = current_user
    @reservation = @review.reservation
  end

  def create
    @review = Review.find(params[:review_id])
    @answer = @review.build_answer(answer_params)
    @answer.user = current_user
    @reservation = @review.reservation

    if @answer.save
      redirect_to @reservation, notice: 'Avaliação enviada com sucesso.'
    else
      flash.now[:notice] = 'Avaliação não enviada.'
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:description)
  end
  
end
