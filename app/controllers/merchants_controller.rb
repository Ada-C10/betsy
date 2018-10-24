class MerchantsController < ApplicationController
  before_action :find_merchant, only: [:show]
  before_action :find_products, only: [:show]
  skip_before_action :require_login, only: [:index, :show]

  def index
    @merchants = Merchant.all.order(:name)
  end

  def show
    @orderitem = Orderitem.new
  end

  def dashboard
    @merchant = Merchant.find_by(id: session[:user_id])
    @orderitems = @merchant.items_by_status("all")
    @pendingitems = Merchant.items_by_orderid(@orderitems["pending"])
    @paiditems = Merchant.items_by_orderid(@orderitems["paid"])
    @completeitems = Merchant.items_by_orderid(@orderitems["complete"])
    @cancelleditems = Merchant.items_by_orderid(@orderitems["cancelled"])
    @products = @merchant.products
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
    @order = Order.find_by(id: order_params[:order_id])
    @merchant = Merchant.find_by(id: order_params[:merchant_id])
    unless @merchant && @order
      return render "layouts/notfound", status: :not_found
    end
    # is this being handled somewhere else?
    unless @merchant.orderitems.any? {|oi|oi.order_id == @order.id}
      return render "layouts/notfound", status: :not_found
    end
    status = order_params[:status]

    if @order.update(status: status)

      flash[:status] = :success
      if status == "complete"
        flash[:result_text] = "Thanks for shipping order ##{@order.id}!"
      elsif status == "paid"
        flash[:result_text] = "Has there been an unexpected delay with Order# #{@order.id}? Customer support is here to help."
      end
      return redirect_back(fallback_location: root_path)
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Could not update order # #{@order.id}"
      flash.now[:messages] = @order.errors.messages
      render "layouts/notfound", status: :bad_request
    end
  end

# params[:order][:order_id]
# params[:order][:merchant_id]
# params[:order][:status]

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

  def order_params
    params.require(:order).permit(:merchant_id, :order_id, :status)
  end
end
