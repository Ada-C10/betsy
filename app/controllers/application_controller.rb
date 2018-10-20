class ApplicationController < ActionController::Base
  before_action :current_user
  before_action :require_login
  before_action :current_cart

  private

  def current_user
    @current_user ||= Merchant.find(session[:user_id]) if session[:user_id]
  end

  def require_login
    if @current_user.nil?
      # flash[:status] = :failure
      # flash[:result_text] = "You must be logged in to view this section"
      redirect_to root_path
    end
  end

  def current_cart
    @current_cart ||= Order.find(session[:order_id]) if session[:order_id]
  end
end
