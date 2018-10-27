class ApplicationController < ActionController::Base
  before_action :current_merchant
  before_action :current_cart
  before_action :require_login

  private

  def current_merchant
    @current_merchant = Merchant.find_by(id: session[:merchant_id])
  end

  def require_login
    if @current_merchant.nil?
      flash[:error] = "You must be logged in to view this section"
      redirect_to root_path
    end
  end

  def current_cart
    existing_cart = session[:order_id]
    existing_cart ? find_shopping_cart : create_shopping_cart
  end

  def find_shopping_cart
    @shopping_cart = Order.find_by(id: session[:order_id])
    return @shopping_cart
  end

  def create_shopping_cart
    @shopping_cart = Order.create!
    session[:order_id] = @shopping_cart.id
    return @shopping_cart
  end

  def find_merchant
    return Merchant.find_by(id: params[:merchant_id])
  end

  def find_category
    return Category.find_by(id: params[:category_id])
  end

  def find_order_item
    return OrderItem.find_by(id: params[:id])
  end

  def find_product
    return Product.find_by(id: params[:id])
  end

  def find_order
    return Order.find_by(id: params[:id])
  end

  def render_404
    render file: "/public/404.html", status: 404
  end

  def render_400
    render :new, status: :bad_request
  end
end
