class OrderitemsController < ApplicationController
  skip_before_action :require_login, only: [:create, :update, :destroy]

  def create # maybe rename this route
    # Think about if things fail to save to DB
    @orderitem = Orderitem.new(orderitem_params)

    if session[:order_id] == nil
      @order = Order.new
      @order.save(validate: false)
  # SJ: I might research a way to put the logic to skip certain validations
  # into the model, rather than here.
      session[:order_id] = @order.id
    end

# Should we made a filter with @currentorder in ApplicationController?

    @order = Order.find_by(id: session[:order_id].to_i)
    @orderitem.order_id = @order.id
    if @orderitem.save
      redirect_to order_path(@order)
    else
      render "layouts/servererror", status: :internal_server_error
    end

  end

  def update
    @orderitem = Orderitem.find_by(id: params[:id].to_i)
    @orderitem.update_attributes(orderitem_params)
    if @orderitem.save
      redirect_to order_path(session[:order_id])
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Could not update your quantity"
      flash.now[:messages] = @orderitem.errors.messages
      render :order_path(session[:order_id]), status: :not_found
    end

  end

  def destroy
    @orderitem = Orderitem.find_by(id: params[:id])
    @orderitem.destroy
    redirect_back(fallback_location: order_path(session[:order_id]))
  end

  private
  def orderitem_params
    params.require(:orderitem).permit(:quantity, :product_id)
  end
end
