class OrderItemsController < ApplicationController
  # TODO:
  # Pushpa (Update relations for Merchants)
  # has_many :order_items, through: products
  def create
    order_item = OrderItem.new(order_items_params)
    order_item.product = Product.find_by(id: params[:id])

    if @cart
      order_item.order_id = @cart.id
    else
      order = Order.create
      order_item.order_id = order.id
      session[:order_id] = order.id
    end

    if order_item.save
      flash[:status] = :success
      flash[:result_text] = "Added item to cart"
      redirect_to order_path(order_item.order)
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not add item to cart"
      flash[:messages] = order_item.errors.messages
      redirect_back fallback_location: root_path
    end

  end

  def update
    @order_item = OrderItem.find_by(id: params[:id])

    if @order_item.update(order_items_params)
      flash[:status] = :success
      flash[:result_text] = "Successfully updated order # #{@order_item.id}."
      redirect_to order_path(@cart)
    else
      flash[:status] = :failure
      flash[:result_text] = "Something went wrong: Could not update order ##{@order_item.id}"
      flash[:messages] = @order_item.errors.messages
      redirect_back(fallback_location: orders_path)
    end

  end

  def destroy
    order_item = OrderItem.find_by(id: params[:id])

    if order_item.nil?
      head :not_found
    end

    order_item.destroy

    flash[:success] = "Successfully removed order # #{order_item.id}"
    redirect_to order_path(@cart)
  end

  private

  def order_items_params
    return params.require(:order_item).permit(:quantity) 
  end

end
