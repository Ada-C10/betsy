class OrderProductsController < ApplicationController

  def create
    # pull in product and quantity from form partial on product show page
    product = Product.find_by(id: params[:order_product][:product_id].to_i)
    quantity = params[:order_product][:quantity].to_i

    # create the orderproduct, add it to the current cart, and save it
    if @current_order.save && @current_order.add_product(product, quantity)
      # save the cart and update the session
      @current_order.save
      session[:order_id] = @current_order.id

      redirect_to cart_path
    else
      flash[:warning] = "Error: Could not add product to cart"

      redirect_back fallback_location: products_path
    end
  end

  def update
    op = OrderProduct.find_by(id: params[:id].to_i)
    new_quantity = params[:order_product][:quantity].to_i

    if @current_order.edit_quantity(op, new_quantity) && @current_order.save
      if new_quantity == 0
        flash[:success] = "Removed #{op.product.name} from cart"
      end
      redirect_to cart_path
    else
      flash[:warning] = "Error: Could not update product order"

      redirect_back fallback_location: cart_path
    end
  end

  def change_status
    op = OrderProduct.find_by(id: params[:id].to_i)
    new_status = params[:status]

    if verify_merchant(op) && op.update(status: new_status)
      flash[:success] = "Updated status for Product Order ##{op.id} to #{new_status}"
      redirect_to merchant_dash_path(@current_user.id)
    elsif verify_buyer(op) && op.update(status: new_status)
      flash[:success] = "Cancelled Product Order ##{op.id}"
      redirect_back fallback_location: root_path
    else
      flash[:warning] = "Could not update status for Product Order ##{op.id}"
      redirect_back fallback_location: root_path
    end
  end

  def destroy
    op = OrderProduct.find_by(id: params[:id])
    if op && op.destroy
      flash[:success] = "Removed #{op.product.name} from cart"
    else
      flash[:warning] = "Error: Could not remove product from cart"
    end
    redirect_back fallback_location: cart_path
  end

  private

    def verify_merchant(op)
      return (op.product.user == @current_user && @current_user.is_a_merchant?)
    end

    def verify_buyer(op)
      return op.order.user == @current_user
    end
end
