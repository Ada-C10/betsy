class ApplicationController < ActionController::Base
  before_action :find_home_category
  before_action :find_logged_in_merchant
  before_action :find_merchants
  before_action :has_cart?, :find_orders
  before_action :find_active_products


  def nosnacks
  end

  private

  def find_home_category
    @categories = Category.all.map
  end

  def find_orders
    if @cart
      @order_items = @cart.order_items.sum do |o_items| o_items.quantity
      end
    else
      @order_items = 0
    end
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

  def find_active_products
    @active_products = Product.all.where(status: true)
  end



end
