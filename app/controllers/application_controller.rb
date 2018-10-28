class ApplicationController < ActionController::Base
  before_action :current_user
  before_action :find_user
  before_action :build_cart
  before_action :all_users
  before_action :all_categories

  helper_method :logged_in?
  helper_method :current_user



  private
  def build_cart
    session[:cart] = Array.new if !session[:cart]
    if session[:cart]
      session[:cart].each.with_index do |hash, index|
        hash.each do |id, quantity|
          product = Product.find_by(id: id)
          if (quantity > product.stock_count) && (product.stock_count > 0)
            session[:cart][index][id] = product.stock_count
            flash[:warning] = "#{product.name.capitalize} has been updated due to a change in availability."
            redirect_back(fallback_location: cart_path)
          elsif (quantity > product.stock_count) && (product.stock_count == 0)
            session[:cart].delete_at(index)
            flash[:danger] = "#{product.name.capitalize} has been removed from your basket due because it is no longer available."
            redirect_back(fallback_location: root_path)
          end
        end
      end
    end
  end

  def logged_in?
    current_user.present?
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def find_user
    @user = User.find_by(id: params[:id])
  end

  def require_login
    if @current_user.nil?
      flash[:danger] = "Sorry, the fulfillment page is only for creature rescuers."
      redirect_to root_path
    end
  end

  def all_users
    @users = User.all
  end

  def all_categories
    @categories = Category.all
  end
end
