class OrderItemsController < ApplicationController

  before_action :find_order_item, only: [:update, :destroy]

  def create
    order_item = OrderItem.new(order_items_params)
    order_item.product = Product.find_by(id: params[:id])

    add_to_cart(order_item)

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

    if is_authorized

      if @order_item.update(order_items_params)
        flash[:status] = :success
        flash[:result_text] = "Successfully updated order for # #{@order_item.product.name}."
        redirect_to order_path(@cart)
      else
        flash[:status] = :failure
        flash[:result_text] = "Something went wrong: Could not update order ##{@order_item.id}"
        flash[:messages] = @order_item.errors.messages
        redirect_back(fallback_location: orders_path)
      end

    else
      flash[:status] = :failure
      flash[:result_text] = "This order is not available to edit"
      render :template => "orders/nosnacks", status: :bad_request
    end
  end

  def destroy

    if is_authorized

      @order_item.destroy
      flash[:status] = :success
      flash[:result_text] = "Successfully removed order items # #{@order_item.id}"
      redirect_to order_path(@cart)
    else
      flash[:status] = :failure
      flash[:result_text] = "This order is not available to delete"
      render :template => "orders/nosnacks", status: :bad_request
    end
  end



  def ship
    @order_item = OrderItem.find_by(id: params[:id])

    @order_item.status ? @order_item.update_attribute(:status, false) : @order_item.update_attribute(:status, true)


    if @order_item.save
      redirect_back fallback_location: root_path
    else
      puts "Failed to update order_item: #{@order_items.status.errors.messages}"
    end

  end



  private

  def order_items_params
    return params.require(:order_item).permit(:quantity)
  end

  def find_order_item
    @order_item = OrderItem.find_by(id: params[:id])
  end

  def add_to_cart(order_item)
    if @cart
      order_item.order_id = @cart.id
    else
      order = Order.create
      order_item.order_id = order.id
      session[:order_id] = order.id
    end
  end

  def is_authorized
    return @cart && @order_item && @cart.id == @order_item.order_id
  end





end
