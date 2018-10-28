class OrdersController < ApplicationController
  before_action :find_order
  skip_before_action :find_order, only: [:fulfillment, :paid, :new, :create, :completed, :cancelled]
  before_action :require_login, only: [:fulfillment, :paid, :completed, :cancelled]

  def new
    @order = Order.new
  end

  def show; end

  def create
    @order = Order.new
    @order.status = "pending"
    @order.save

    Orderproduct.create_product_orders(@order.id, session[:cart])
    if session[:cart].length != @order.orderproducts.length
      @order.orderproducts.each do |orderproduct|
        orderproduct.destroy
      end
      flash[:danger] = 'Unable to complete adoption request, creature not available.'
      render :new, status: :bad_request
    else
      @order.total_cost = @order.order_total
      @order.update(order_params)
      if @order.save
        @order.reduce_stock
        @order.status = "paid"
        @order.save
        flash[:success] = "Adoption request successfully placed! (Order ##{@order.id})"
        session[:cart] = nil
        redirect_to order_path(@order.id)
      else
        @order.destroy
        flash.now[:messages] = @order.errors.messages
        render :new, status: :bad_request
      end
    end
  end


  def update
    @order.update(order_params)
    if @order && @order.save
      flash[:success] = 'Status has been changed.'
      redirect_to order_path(@order.id)
    else
      flash[:danger] = 'Adoption request was not updated.'
      redirect_to order_path(@order.id)
    end
  end

  def fulfillment
    if @current_user
      @orderproducts = Order.find_orderproducts(@current_user, nil)
      @total_revenue = Order.products_sold_total(@current_user, @orderproducts)
      @count = Order.count_orders(@current_user, nil)
    else
      flash[:danger] = 'Sorry, the fulfillment page is only for creature rescuers.'
      redirect_to root_path
    end
  end

  def paid
    if @current_user
      @orderproducts = Order.find_orderproducts(@current_user, "paid")
      @total_revenue = Order.products_sold_total(@current_user, @orderproducts)
      @count = Order.count_orders(@current_user, "paid")
    else
      flash[:danger] = 'Sorry, the fulfillment page is only for creature rescuers.'
      redirect_to root_path
    end
  end

  def completed
    if @current_user
      @orderproducts = Order.find_orderproducts(@current_user, "completed")
      @total_revenue = Order.products_sold_total(@current_user, @orderproducts)
      @count = Order.count_orders(@current_user, "completed")
    else
      flash[:danger] = 'Sorry, the fulfillment page is only for creature rescuers.'
      redirect_to root_path
    end
  end

  def cancelled
    if @current_user
      @orderproducts = Order.find_orderproducts(@current_user, "cancelled")
      @total_revenue = Order.products_sold_total(@current_user, @orderproducts)
      @count = Order.count_orders(@current_user, "cancelled")
    else
      flash[:danger] = 'Sorry, the fulfillment page is only for creature rescuers.'
      redirect_to root_path
    end
  end

  def search
    if @order
      redirect_to order_path(@order)
    else
      flash[:danger] = "Adoption request #{params[:id]} does not exist"
      redirect_back fallback_location: root_path
    end
  end


  private

  def find_order
    @order = Order.find_by(id: params[:id].to_i)

    if @order.nil?
      flash.now[:danger] = "Cannot find adoption request ##{params[:id]}"
      render :notfound, status: :not_found
    end
  end

  def order_params
    return params.require(:order).permit(:name, :email, :mailing_address, :zip_code, :cc_number, :cc_expiration, :cc_cvv, :total_cost, :status)
  end

end
