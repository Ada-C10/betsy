class OrderitemsController < ApplicationController
  skip_before_action :require_login, only: [:create]

  def index
  end

  def show
  end

  def new
  end

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
