class OrderitemsController < ApplicationController
  before_action :find_orderitem, only: [:update, :destroy]
  skip_before_action :require_login, only: [:create, :update, :destroy]

  # Test #3 not done (regarding how to test sessions)
  def create
    @orderitem = Orderitem.new(orderitem_params)

    # if session[:user_id] exists, then can update @current_cart.name = merchant.name etc
    # merchant edit view for checkout, autofill name, email
    if session[:order_id] == nil
      @order = Order.create
      session[:order_id] = @order.id
    end

    @order = Order.find_by(id: session[:order_id].to_i)
    @orderitem.order_id = @order.id
    if @orderitem.save
      redirect_to order_path(@order.id)
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not save"
      flash[:messages] = @orderitem.errors.messages
      render "layouts/servererror", status: :internal_server_error
    end

  end

  def update
    if @orderitem.update(orderitem_params)
      redirect_back(fallback_location: root_path)
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Could not update your quantity"
      flash.now[:messages] = @orderitem.errors.messages
      render :edit, status: :bad_request
    end
  end

  # Test Done
  def destroy
    @orderitem.destroy
    redirect_back(fallback_location: root_path)
  end

  private
  def orderitem_params
    params.require(:orderitem).permit(:quantity, :product_id)
  end

  def find_orderitem
    @orderitem = Orderitem.find_by(id: params[:id].to_i)

    if @orderitem.nil?
      render "layouts/notfound", status: :not_found
    end
  end
end
