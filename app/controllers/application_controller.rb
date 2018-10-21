class ApplicationController < ActionController::Base
  before_action :find_home_category
  before_action :find_merchants
  before_action :find_orders

  private

  def find_home_category
    @categories = Category.all.map
  end

  def find_merchants
    @merchants = Merchant.all.map
  end

  def find_orders
    # TODO KA: @orders should be the count of order-items
    # for the specific customer (match with session/Oauth user)

    @orders = OrderItem.all
  end

end
