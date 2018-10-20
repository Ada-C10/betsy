class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :current_order
  before_action :current_user
  before_action :require_login

  private

  def current_user
    @current_user ||= Merchant.find(session[:user_id]) if session[:user_id]
  end

  def require_login
    if current_user.nil?
      # flash[:status] = :failure
      # flash[:result_text] = "You must be logged in to view this section"
      redirect_to root_path
    end
  end

  def current_order
    @current_order ||= Order.find_by(id: session[:order_id]) if session[:order_id]
  end
end
