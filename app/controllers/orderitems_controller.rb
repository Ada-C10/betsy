class OrderitemsController < ApplicationController
  def index
  end

  def show
  end

  def new
  end

  def create # maybe rename this route
    # Think about if things fail to save to DB
    @orderitem = Orderitem.new(orderitem_params)

    if session[:user_id] == nil
      @guest = Guest.create(validate: false)
      Order.create(guest_id: @guest.id)
      session[:user_id] = @guest.id
    end

    @order = Order.find_by(guest_id: @guest.id)
    @orderitem.order_id = @order.id
    if @orderitem.save
      redirect_to order_path(@order.id)
    else
      render :notfound, status: :bad_request #Reconsider This
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def orderitem_params
    params.require(:orderitem).permit(:quantity, :product_id)
  end
end
