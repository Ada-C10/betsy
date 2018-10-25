class OrdersController < ApplicationController
  before_action :find_order, only: [:edit, :update]
  skip_before_action :require_login

  def show
    id = params[:id]
    if id == "cart" && session[:order_id] == nil
      @orderitems = []
    elsif id == "cart" || session[:order_id] == id.to_i
      @order = Order.find_by(id: session[:order_id])
      if @order
        @orderitems = @order.orderitems.order(created_at: :desc)
      end
    else
      @order = Order.find_by(id: id.to_i)
      if @order && @order.status != "pending"
        @orderitems = @order.orderitems.order(created_at: :desc)
      else
        render "layouts/notfound", status: :not_found
      end
    end
  end

  def edit
    if @current_user
      @order.name = @current_user.name
      @order.email = @current_user.email
      @order.save
    end
    @total_cost = @order.total_cost
  end

  def update
    @order_items = Orderitem.where(order_id: @order.id)
    if Product.check_inventory(@order_items)
      Product.adjust_inventory(@order_items)

      @order.status = "paid"

      if @order.update_attributes(order_params)
        redirect_to order_path(@order.id)
      else
        flash.now[:status] = :failure
        flash.now[:result_text] = "Could not complete order"
        flash.now[:messages] = @order.errors.messages
        return render :edit, status: :bad_request
      end

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
