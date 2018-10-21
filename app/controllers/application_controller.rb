class ApplicationController < ActionController::Base
  before_action :find_home_category
  before_action :find_logged_in_merchant
  before_action :find_merchants

  private

  def find_home_category
    @categories = Category.all.map
  end

  def find_orders
    @order_items = OrderItem.all
  end

  def find_merchants
    @merchants = Merchant.all.map
  end


  def find_logged_in_merchant
    @logged_in_merchant = Merchant.find_by(id: session[:merchant_id])
  end


end
