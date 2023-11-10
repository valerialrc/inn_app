class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :check_for_inn, unless: :devise_controller?

  private

  def check_for_inn
    if user_signed_in? && !Inn.exists?(user_id: current_user.id)
      redirect_to new_inn_path, notice: "Você precisa cadastrar uma pousada antes de continuar."
    end
  end
 
  def after_sign_in_path_for(resource_or_scope)
    if resource_or_scope.is_a?(User)
      if Inn.exists?(user_id: current_user.id)
        super
      else
        new_inn_path
      end
    else
      super
    end
  end
end