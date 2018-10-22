class OrderItemsController < ApplicationController
  # TODO:
  # Pushpa (Update relations for Merchants)
  # has_many :order_items, through: products
  
  def update
    if @order_item.update(order_items_params)
      flash[:success] = "Successfully updated order # #{@order_item.id}."
      redirect_to orders_path
    else
      flash.now[:error] = "Something went wrong: Could not update order ##{@order_item.id}"
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
    redirect_to orders_path
  end

  def order_items_params
    return params.require(:order_item).permit(:quantity)
  end
end
