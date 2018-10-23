class MerchantsController < ApplicationController
  before_action :find_merchant, only: [:show]
  skip_before_action :require_login, only: [:index, :show]

  def index
    @merchants = Merchant.all.order(:name)
  end

  def show
    @orderitem = Orderitem.new
    @products = @merchant.products
  end

  def dashboard
    @merchant = @current_user
    @products = @merchant.products
    @orderitems = @merchant.items_by_status("all")
    @pendingitems = Merchant.items_by_orderid(@orderitems["pending"])
    @paiditems = Merchant.items_by_orderid(@orderitems["paid"])
    @completeitems = Merchant.items_by_orderid(@orderitems["complete"])
    @cancelleditems = Merchant.items_by_orderid(@orderitems["cancelled"])
  end

  private
  def find_merchant
    @merchant = Merchant.find_by(id: params[:id].to_i)

    unless @merchant
      render "layouts/notfound", status: :not_found
    end
  end

  def merchant_params
    params.require(:merchant).permit(:name, :email, :avatar_url, :uid, :provider)
  end
end
