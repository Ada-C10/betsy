class OrderItemsController < ApplicationController
  skip_before_action :require_login

  def create
    product_id = params[:order_item][:product_id].to_i
    product = Product.find_by(id: product_id)

    if @current_merchant == product.merchant
      flash[:error] = "Cannot add your own product to the cart"
      redirect_to dashboard_path
      return
    end

    @shopping_cart.order_items.each do |order_item|
      if order_item.product.id == product_id
        old_qty = order_item.quantity.to_i
        requested_qty = params[:order_item][:quantity].to_i
        new_qty = old_qty + requested_qty

        if order_item.update(quantity: new_qty)
          flash[:success] = "Successfully updated quantity"
          redirect_to cart_path
        end
        return
      end
    end

    unless quantity_is_in_stock?(product_id)
      cannot_order_more_than_stock
      return
    end

    @order_item = @shopping_cart.order_items.new(order_item_params)
    successful_save = @order_item.save
    successful_save ? added_to_cart : could_not_add_to_cart
  end

  def update
    @order_item = find_order_item
    product_id = @order_item.product_id

    unless pending_status?
      cannot_update_paid_order_item
      return
    end

    unless quantity_is_in_stock?(product_id)
      cannot_order_more_than_stock
      return
    end

    @order_item.update(order_item_params)
    successful_update = @order_item.save
    successful_update ? order_item_updated : could_not_update
  end

  def destroy
    @order_item = find_order_item
    pending_status? ? order_item_destroyed : could_not_destroy
  end

  def update_order_item_status
    valid_statuses = ["shipped", "cancelled"]
    order_item_status = params[:status]
    @order_item = find_order_item

    if @current_merchant != @order_item.merchant
      flash[:alert] = "You do not have access to change the status of this order item"
    end

    if @order_item && valid_statuses.include?(order_item_status) && @order_item.merchant == @current_merchant
        @order_item.update(status: order_item_status)
        flash[:success] = "Successfully changed that order status"
    else
      flash[:alert] = "Something about that request doesn't exist"
    end
    redirect_to dashboard_path
  end

  private

  def cannot_update_paid_order_item
    flash[:error] = "Cannot update an order item that is not pending"
    redirect_to root_path
  end

  def pending_status?
    return @order_item.status == 'pending'
  end

  def could_not_destroy
    flash[:failure] = "Could not delete item from cart due to status being \'#{@order_item.status}\'"
    redirect_to root_path
  end

  def order_item_destroyed
    @order_item.destroy
    flash[:success] = "Successfully deleted item from cart"
    redirect_to cart_path
  end

  def could_not_update
    flash[:error] = @order_item.errors.messages
    redirect_to root_path
  end

  def order_item_updated
    flash[:success] = "Successfully updated item"
    redirect_to cart_path
  end

  def could_not_add_to_cart
    flash[:failure] = "Could not add to cart"
    flash[:messages] = @order_item.errors.messages
    redirect_to root_path
  end

  def added_to_cart
    flash[:success] = "Successfully added to cart"
    redirect_to cart_path
  end

  def cannot_order_more_than_stock
    flash[:error] = "Cannot order more than inventory"
    redirect_to root_path
  end

  def quantity_is_in_stock?(product_id)
    product = find_order_item_product(product_id)
    quantity = params[:order_item][:quantity].to_i
    inventory = product.inventory
    return quantity <= inventory
  end

  def find_order_item_product(product_id)
    return Product.find_by(id: product_id)
  end

  def order_item_params
    params.require(:order_item).permit(:quantity, :product_id)
  end
end
