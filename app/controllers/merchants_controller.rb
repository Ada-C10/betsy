class MerchantsController < ApplicationController
  before_action :find_merchant, only: [:show, :dashboard]
  before_action :find_products, only: [:show, :dashboard]
  skip_before_action :require_login, only: [:index, :show]

  def index
    @merchants = Merchant.all.order(:name)
  end

  def show
    @orderitem = Orderitem.new
  end

  def dashboard
    @merchant = Merchant.find_by(id:session[:user_id])
    unless @merchant
      render "layouts/notfound", status: :not_found
    end
    @orderitems = @merchant.items_by_status("all")
    @pendingitems = Merchant.items_by_orderid(@orderitems["pending"])
    @paiditems = Merchant.items_by_orderid(@orderitems["paid"])
    @completeitems = Merchant.items_by_orderid(@orderitems["complete"])
    @cancelleditems = Merchant.items_by_orderid(@orderitems["cancelled"])
    @activeproducts = @products.order(:name).where(active: true).where("inventory > ?", 0)
    @soldout = @products.order(:name).where(active: true).where(inventory: 0)
    @inactive = @products.order(:name).where(active: false)
  end

  def customer
    @order = Order.find_by(id: params[:order_id])
    @merchant = Merchant.find_by(id: params[:merchant_id])
    unless @merchant && @order
      return render "layouts/notfound", status: :not_found
    end
    @orderitems = Merchant.items_by_orderid(@merchant.orderitems)[@order.id]
  end

  def ship
    # @order = Order.find_by(id: params[:id])
# updates the Order status to complete
# rendeer not found
  end

  private
  def find_merchant
    @merchant = Merchant.find_by(id: params[:id].to_i)

    unless @merchant
      render "layouts/notfound", status: :not_found
    end
  end

  def find_products
    @products = @merchant.products
  end
end
