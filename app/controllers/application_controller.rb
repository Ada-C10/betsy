class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :current_user
  before_action :require_login

  private

  def current_user
    @current_user ||= Merchant.find_by(id: session[:user_id]) if session[:user_id]
  end

  def require_login
    if current_user.nil?
      redirect_to root_path
    end
  end
end
