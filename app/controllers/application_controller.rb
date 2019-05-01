class ApplicationController < ActionController::Base

  before_action :list_categories, :list_merchants, :current_order
  # before_action :list_categories, :list_merchants
  before_action :require_login, except: [:current_order, :render_404, :find_user]
  before_action :find_user

  helper_method :current_order

  def list_categories
    @categories = Category.all
  end

  def list_merchants
    @users = User.all
  end

  def current_order
    if session[:order_id]
      @current_order = Order.find(session[:order_id])

    # else
    #   @current_order = Order.new
    end
    #
    # return @current_order
  end

  def render_404
    raise ActionController::RoutingError.new('Not Found')
  end

  private
  def find_user
    if session[:user_id]
      @login_user ||= User.find(session[:user_id]) if session[:user_id]
    end
  end


  def require_login
    if session[:user_id].nil?
      flash[:error] = "You must be logged in to view this section"
      redirect_to root_path
    end
  end

end
