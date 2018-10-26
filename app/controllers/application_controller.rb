class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :find_merchant

  def render_404
    # DPR: this will actually render a 404 page in production
    raise ActionController::RoutingError.new('Not Found')
  end

  # return the current order or create a new order if none exists
  def current_order
    if !session[:order_id]
      new_order = Order.new()
      session[:order_id] = new_order.id
      result = new_order.save
      if result
        # flash[:status] = :success
        # flash[:result_text] = "Added item to your cart"
        # redirect_to root_path
        return new_order.id
      else
        # flash[:status] = :failure
        # flash[:result_text] = "Could not add to order"
        # redirect_to root_path
      end

    elsif
      ongoing_order = Order.find_by(id: session[:order_id])
      flash[:status] = :failure
      flash[:result_text] = "You already have a cart in progress."
      # redirect_to root_path
      return ongoing_order.id
    else
      puts "oh no"
      flash[:status] = :failure
      flash[:result_text] = "Your order does not exist."
      redirect_to root_path
    end

  end

  private

  # NOTE: can dry the code above private with this
  def find_order
    if session[:order_id]
      @ongoing_order = Order.find_by(id: session[:order_id])
    end
  end

  def find_merchant
    if session[:merchant_id]
      @login_user = Merchant.find_by(id: session[:merchant_id])
    end
  end

  def require_login
    if find_merchant.nil?
      flash[:status] = :failure
      flash[:result_text] = "You must be a logged in merchant to view this page."
      redirect_to root_path
    end
  end

end
