class OrderItemsController < ApplicationController



  def create
    #TODO: translate into strong params

    @order_item = OrderItem.new(product_id: params[:product_id].to_i, quantity: params[:quantity].to_i, order_id: current_order)
    session[:order_id] = @order_item.order.id
    # order_id = OrderItem.add_order_item_to_order(@order_item)
    # @order_item.order_id = order_id

    # TODO: add if/else or model method to check against + edit product inventory

    result = @order_item.save

    if result
      flash[:status] = :success
      flash[:result_text] = "Successfully created
      order item #{@order_item.product.name}."

    else
      flash[:status] = :failure
      flash[:result_text] = "DID NOT create order item #{order_id}"
      flash[:messages] = @order_item.errors.messages
    end

    redirect_back(fallback_location: root_path)
  end

  def update
    @order_item = OrderItem.find_by(id: params[:order_item_id])

    @order_item.update(quantity: params[:quantity])

    if @order_item.save
      flash[:status] = :success
      flash[:result_text] = "Successfully updated order item: #{@order_item.product.name}"
      flash[:messages] = @order_item.errors.messages
    else
      flash[:status] = :failure
      flash[:result_text] = "Did not update order item: #{@order_item.product.name}"
      flash[:messages] = @order_item.errors.messages
    end
    redirect_to orders_path

  end

  def change_shipping_status
    @order_item = OrderItem.find_by(id: params[:order_item_id])

    @order_item.update(shipped: params[:shipped])

    if @order_item.save
      flash[:status] = :success
      flash[:result_text] = "Successfully changed shipping status for item #{@order_item.product.name}"
      flash[:messages] = @order_item.errors.messages
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not change shipping status for order item #{@order_item.product.name}"
      flash[:messages] = @order_item.errors.messages
    end

    redirect_back(fallback_location: root_path)
  end


  # NOTE: actions below are for order... should instead be for order_item?

  # def update
  #   @order = current_order
  #   @order_item = @order.order_items.find(params[:id])
  #   @order_item.update_attributes(order_item_params)
  #   @order_items = @order.order_items
  # end

  # def destroy
  #   @order = current_order
  #   @order_item = @order.order_items.find(params[:id])
  #   @order_item.destroy
  #   @order_items = @order.order_items
  # end

  def destroy
    @order_item = OrderItem.find_by(id: params[:id])

    result = @order_item.destroy

    if result
      flash[:status] = :success
      flash[:result_text] = "Successfully destroyed item: #{@order_item.product.name}"
      redirect_to orders_path
    else
      flash[:status] = :failure
      flash[:result_text] = "Did not delete #{@order_item.product.name}"
      flash[:messages] = @order_item.errors.messages
    end
  end

  # private
  #
  # def order_item_params
  #   params.require(:order_items).permit(:product_id, :quantity)
  # end

 # end



end
