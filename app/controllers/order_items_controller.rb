class OrderItemsController < ApplicationController

  def create

    @order = Order.find_by(id: session[:order_id])
    @item = Item.find_by(id: params[:item_id])


    @order_item = @order.order_items.new(
      item_id: @item.id,
      quantity_per_item: params[:quantity_per_item]
    )

    if @order_item.save
      # session[:order_id] = @order.id
      flash[:success] = "Item successfully added to your cart!"
      redirect_to order_path(@order.id)

    else
      flash.now[:error] = "Order item contains bad data."
      redirect_to item_path(@item.id), status: :bad_request
    end

  end



  def update
    @order = Order.find_by(id: session[:order_id])
    @order_item = @order.order_items.find_by(id: params[:id])

    success = @order_item.update(quantity_per_item: params[:quantity_per_item])

    if success
      flash[:success] = "Item successfully updated."
      redirect_to order_path(@order)
    end
  end


  def increment_quantity
    @order = Order.find_by(id: session[:order_id])
    @order_item = @order.order_items.find_by(item_id: params[:item_id])
    @item = Item.find_by(id: @order_item.item_id)

    additional_quantity = params[:quantity_per_item].to_i

    new_quantity = @order_item.quantity_per_item + additional_quantity

    if new_quantity > @item.quantity_available
      flash[:error] = "Whoops! You already have a few of these babies in your cart and we only have #{@item.quantity_available} available. Please check your quantity and try again."
      redirect_to order_path(@order)
    else
      success = @order_item.update(quantity_per_item: new_quantity)
      if success
        flash[:success] = "Item quantity updated."
        redirect_to order_path(@order)
      end
    end
  end


  def destroy
    @order = Order.find_by(id: session[:order_id])
    @order_item = @order.order_items.find(params[:id])
    success = @order_item.destroy

    if success
      flash[:success] = "Item successfully deleted."
      redirect_to order_path(@order)
    end
  end


  private
  def order_item_params
    params.require(:order_item).permit(:shipped, :order_id, :item_id, :quantity_per_item)
  end

end
