class OrdersController < ApplicationController
  before_action :find_order, only: [:edit, :update]
  skip_before_action :require_login, only: [:show, :edit, :update, :confirmation]

  def index
    @orders = Order.find_by(id: session[:user_id])
  end

  def show
    if params[:id] == "cart"
      @orderitems = []
    else
      @order = Order.find_by(id: session[:order_id])
      if session[:order_id]
        @orderitems = @order.orderitems.order(created_at: :desc)
      end
    end
  end

  def new
  end

  def create
  end

  def edit; end

  def update
    @order.status = "paid"
    @order_items = Orderitem.where(order_id: @order.id)
    Product.adjust_inventory(@order_items)

    if @order.update_attributes(order_params)
      redirect_to confirmation_path
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Could not complete order"
      flash.now[:messages] = @order.errors.messages
      render "layouts/notfound", status: :not_found
    end
  end

  def destroy
  end

  def confirmation
    @order = Order.find_by(id: session[:order_id])

    if @order.nil?
      render "layouts/notfound", status: :not_found
    elsif @order.status == "pending"
    else
      @orderitems = @order.orderitems
      session[:order_id] = nil
    end
  end

  private

  def find_order
    @order = Order.find_by(id: session[:order_id])

    if @order.nil?
      render "layouts/notfound", status: :not_found
    end
  end

  def order_params
    params.require(:order).permit(:name, :address, :cc_num, :exp_date, :zip, :cvv, :email)
  end
end
