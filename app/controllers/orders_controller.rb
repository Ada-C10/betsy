class OrdersController < ApplicationController
  def cart
  end

  def checkout
    unless @current_order.order_products.any?
      redirect_to cart_path
      flash[:warning] = "You must add something to your cart before you can checkout"
    end
  end

  def update
    if @current_order.update(order_user_params) && @current_order.submit_order

      session[:paid_order_id] = session[:order_id]
      session[:order_id] = nil

      redirect_to confirmation_path
    else
      redirect_to checkout_path
      flash[:warning] = "Could not submit order"
    end
  end

  def confirmation
    @paid_order = Order.find_by(id: session[:paid_order_id])

    if @paid_order
      session[:paid_order_id] = nil
    else
      redirect_to checkout_path
      flash[:warning] = "Error: Order payment did not go through"
    end
  end

  private

    def order_user_params
      return params.require(:order).permit(user_attributes: [:id, :name, :address, :email, :cc_num, :cc_csv, :cc_exp, :bill_zip])
    end
end
