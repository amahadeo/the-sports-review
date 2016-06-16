class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  rescue_from Pundit::NotAuthorizedError do |exception|
    if current_user
      redirect_to root_url, alert: "Sorry, not authorized for that page!"
    else
      redirect_to root_url, alert: "Sorry, not authorized for that page, please log in."
    end
  end
  
  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:avatar, :avatar_cache])
  end
end
