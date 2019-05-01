class OrderItemsController < ApplicationController
  skip_before_action :require_login
  # before_action :set_order, only: [:ship]


  def create
    product = Product.find_by(id: params[:order_item][:product_id])
    if params[:order_item][:qty].to_i > product.inv_qty
      flash[:warning] = "Quantity selected exceeds amount availabe in inventory"
      redirect_to product_path(product.id)
    elsif @current_order.nil?
      @current_order = Order.new
      @current_order.save
    end

    @order_item = @current_order.order_items.new(order_item_params)
    @order_item.save
    @current_order.save
    @current_order.update(status: "Pending")
    session[:order_id] = @current_order.id
    redirect_to cart_path(@current_order.id)
    # else
    #   flash[:warning] = "Item order not placed"
    #   redirect_to root_path
  #   # end
  end

  def update
    product = Product.find_by(id: params[:order_item][:product_id])
    if params[:order_item][:qty].to_i > product.inv_qty
      flash[:warning] = "Quantity selected exceeds amount available in inventory"
      redirect_to product_path(product.id)
    else
      @order_item = @current_order.order_items.find_by(id: params[:id])
      if @order_item.nil?
        flash[:warning] = "Order item not found"
        redirect_to root_path
      else
        @order_item.update_attributes(order_item_params)
        @current_order.save

        if @order_item.save
          redirect_to cart_path(@current_order.id)
        else
          flash[:warning] = "Item order not updated"
          redirect_to root_path
        end
      end
    end
  end


  def cart_direct
    product = Product.find_by(id: params[:id])
    if product.inv_qty == 0
      flash[:warning] = "Product is out of stock"
      redirect_to products_path
    elsif @current_order.nil?
      @current_order = Order.new
      @current_order.save
    end
      
    @order_item = @current_order.order_items.new(product_id: params[:id], qty: 1, shipped: false)
    @order_item.save
    @current_order.save

    session[:order_id] = @current_order.id
    redirect_to cart_path(@current_order.id)
  end

  def destroy
    @order_item = @current_order.order_items.find(params[:id])
    @order_item.destroy
    @order_items = @current_order.order_items

    redirect_to cart_path(@current_order.id)
  end

  def ship
    @order_item = OrderItem.find_by(order_id: params[:id])
    @order_item.update(shipped: true)
    @order_item.order.check_order_status
    @order = @order_item.order
    @order.save
    if @order_item.save
      flash[:success] = 'Item(s) have been marked as shipped'
      redirect_back(fallback_location: root_path)
    else
      flash.now[:warning] = 'Error in shipment status.'
      # render :show
    end
  end

  private

  def order_item_params
    params.require(:order_item).permit(:product_id, :qty, :shipped)
  end

  def set_order
    @order = current_order
  end

end
