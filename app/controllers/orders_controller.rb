class OrdersController < ApplicationController

  before_action :in_session?

  def index
  end

  def show
  end

  def create
    @order = Order.new

    @order.status = 'pending'

    if @order.save

      session[:user_id] = @order.id
      order_item = Order_Item.new(order_item_params)
      order_item.order_id = @order.id

      if order_item.save
        flash[:status] = :success
        flash[:result_text] = "Added item to cart"

        redirect_to order_path(@order)
        break
      else
        flash[:status] = :failure
        flash[:result_text] = "Could not add item to cart"
        flash[:messages] = order_item.errors.messages
        redirect_back fallback_location: root_path
        # render :new, status: :bad_request
      end

    else
      flash[:status] = :failure
      flash[:result_text] = "Problems with adding to cart"
      flash[:messages] = @order.errors.messages
      redirect_back fallback_location: root_path
    end

  end

  def edit
  end

  def update
  end

  def confirmation
  end

  private

  def order_params
    params.require(:order).permit(
      :name,
      :email,
      :address,
      :cc_num,
      :cvv,
      :exp_date,
      :zip
    )
  end

  def order_item_params
    params.require(:order_item).permit(
      :quantity
    )
  end


  def in_session?
    return @in_session = session[:user_id]
  end

end
