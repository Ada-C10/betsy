class OrdersController < ApplicationController

  # before_action :has_cart?, :logged_in_merchant?

  def index
  end

  def show
    @order = Order.find_by(id: params[:id])
    render_404 unless @order
  end

  def create
    @order = Order.new

    # @order.status = 'pending'

    if @order.save

      session[:order_id] = @order.id
      order_item = OrderItem.new(order_items_params)
      order_item.order_id = @order.id
      order_item.product = Product.find_by(id: params[:product_id])

      if order_item.save
        # raise
        flash[:status] = :success
        flash[:result_text] = "Added item to cart"

        redirect_to order_path(@order)
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
    @order = Order.find_by(id: params[:id])
  end

  def update
    @order = Order.find_by(id: params[:id])
    @order.update_attributes(order_params)
    if @order.save
      @order.update_attribute(:order_placed, @order.updated_at)
      flash[:status] = :success
      flash[:result_text] = "Order Complete"

      # redirect_to confirmation_path(@order) <-- make this
      session[:order_id] = nil
      redirect_to root_path
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Could not complete order"
      flash.now[:messages] = @order.errors.messages
      render :edit, status: :bad_request
    end
  end

  def confirmation
    @order = Order.find_by(id: params[:id])
  end

  private

  # <ActionController::Parameters {"name"=>"a", "email"=>"test@email.com", "address"=>"123", "cc_num"=>"a", "cvv"=>"1", "exp_date"=>"1", "zip"=>"1"} permitted: true>

  def order_params
    params.require(:order).permit(
      :name,
      :email,
      :address,
      :cc_num,
      :cvv,
      :exp_date,
      :zip,
      :status
    )
  end

  def order_items_params
    params.require(:order_item).permit(
      :quantity,
      :product_id
    )
  end

  # def has_cart?
  #   return @cart = session[:order_id]
  # end
  #
  # def logged_in_merchant?
  #   return @logged_in_merchant = session[:merchant_id]
  # end

end
