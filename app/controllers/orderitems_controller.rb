class OrderitemsController < ApplicationController
  skip_before_action :require_login, only: [:create, :update, :destroy]

  def create # maybe rename this route
    # Think about if things fail to save to DB

    @orderitem = Orderitem.new(orderitem_params)

    # if session[:order_id] == nil
    #   @order = Order.create
    #   session[:order_id] = @order.id
    # end

    @order = Order.find_by(id: session[:order_id].to_i)
    @orderitem.order_id = @order.id
    if @orderitem.save
      redirect_to order_path(@order.id)
      # If orderitem product id is not unique within scope order,
      # redirect to patch order
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not save"
      flash[:messages] = @orderitem.errors.messages
      render "layouts/servererror", status: :internal_server_error
    end

  end

  def update
    # if quantity = 0, redirect_to :destroy
    # add validation: orderitem product_id must be unique within scope order

    @orderitem = Orderitem.find_by(id: params[:id].to_i)
    @orderitem.update_attributes(orderitem_params)
    unless @orderitem.save
      flash.now[:status] = :failure
      flash.now[:result_text] = "Could not update your quantity"
      flash.now[:messages] = @orderitem.errors.messages
      render "layouts/notfound", status: :not_found
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @orderitem = Orderitem.find_by(id: params[:id])
    @orderitem.destroy
    redirect_back(fallback_location: root_path)
  end

  private
  def orderitem_params
    params.require(:orderitem).permit(:quantity, :product_id)
  end
end
