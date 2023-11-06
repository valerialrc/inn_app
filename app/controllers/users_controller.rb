class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user_params = params.require(:user).permit(:email, :password, :password_confirmation)
    @user = User.new(email: user_params[:email], password: user_params[:password])

    unless user_params[:password].eql?(user_params[:password_confirmation])
      flash.now[:notice] = 'Usuário não cadastrado. Senhas diferentes.'
      render 'new'
      return
    end

    if @user.save
      redirect_to root_path, notice: "Usuário cadastrado com sucesso!"
    else
      flash.now[:notice] = 'Usuário não cadastrado.'
      render 'new'
    end
  end
end