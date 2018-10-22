class ApplicationController < ActionController::Base
  before_action :find_merchant
  before_action :is_merchant?
  before_action :set_order
  before_action :find_user

  # def render_404
  #   # DPR: this will actually render a 404 page in production
  #   raise ActionController::RoutingError.new('Not Found')
  # end

  private

  def find_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_login
    if User.find_by(provider: 'github').nil?
      flash[:danger] = "You must be logged in to view this section"
      redirect_to root_path
    end
  end

  def find_merchant
    @merchant = User.find_by(id: session[:user_id], provider: 'github')
  end

  def is_merchant?
    return @merchant
  end

  def find_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def set_order
    #Does an order exist?
    @order = Order.find_by(id:session[:order_id])

    #There is no order in the db
    if @order.nil?
      if is_merchant? #Does the order have a merchant?
        @order = Order.create(user_id: @merchant.id, status: "pending")
        session[:order_id] = @order.id
      else #They are checking out as a guest, there won't be a user_id relation
        @order = Order.create(status: "pending")
        session[:order_id] = @order.id
      end
    end
  end
end
