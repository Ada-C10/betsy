class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :find_merchant

  def render_404
    # DPR: this will actually render a 404 page in production
    raise ActionController::RoutingError.new('Not Found')
  end

  # return the current order or create a new order if none exists
  def current_order
    if session[:order_id].nil? || session[:order_id].empty?
      new_order = Order.new()
      session[:order_id] = new_order.id
      flash[:status] = :success
      flash[:result_text] = "Added item to your cart"
      redirect_to root_path
      return new_order.id


    elsif
      ongoing_order = Order.find_by(id: session[:order_id])
      flash[:status] = :failure
      flash[:result_text] = "Could not add to order"
      redirect_to root_path
      return ongoing_order.id
    else
      # TODO: what if not found?
      puts "oh no"

    end
  end

  private
  def find_merchant
    if session[:merchant_id]
      @login_user = Merchant.find_by(id: session[:merchant_id])
    end
  end


end
