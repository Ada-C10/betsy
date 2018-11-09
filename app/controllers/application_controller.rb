
class ApplicationController < ActionController::Base


  before_action :find_current_user
  before_action :find_all_merchants
  before_action :current_order
  # before_action :require_login, except: :index

  private

  def find_current_user
    @current_user = User.find_by(id: session[:user_id])
    # else
    # @guest_user = #allocated guest or User.find_by()
    # end
  end

  #find all merchants
  # @merchants = User.where(products: [])
  #find all merchants
  def find_all_merchants
    active_products = Item.where(active: true)

    distinct_merchant_objects = active_products.select(:user_id).distinct
    @merchant_ids = distinct_merchant_objects.map do |merchant|
      merchant.user_id
    end

    return @merchant_ids

  end

  def require_login
    unless @current_user
      flash[:error] = "You must be logged in to do that."
      redirect_to root_path
    end
  end

  def current_order

    if session[:order_id]

      # Order.find_by(id: session[:order_id])
      @current_shopper_order_id = session[:order_id]
    
    else
      new_order = Order.create

      session[:order_id] = new_order.id
      @current_shopper_order_id = session[:order_id]
      # raise
    end
  end

end
