class ApplicationController < ActionController::Base
  before_action :find_home_category
  before_action :find_logged_in_merchant
  before_action :find_merchants
  before_action :has_cart?, :find_orders

  private

  def find_home_category
    @categories = Category.all.map
  end

  def find_orders
    @order_items = @cart.order_items
  end

  def find_merchants
    @merchants = Merchant.all.map
  end


  def find_logged_in_merchant
    @logged_in_merchant = Merchant.find_by(id: session[:merchant_id])
  end

  def has_cart?
    return @cart = Order.find_by(id: session[:order_id])
  end


end
