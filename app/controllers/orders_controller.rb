
class OrdersController < ApplicationController
  skip_before_action :require_login
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :check_status, only: [:show]

  # GET /orders
  def index
    @orders = Order.all
  end

  # show Confirmation Page
  def show
    @order = Order.find_by(id: session[:order_id])
    @order_items = Order.find_by(id: session[:order_id]).order_items
    # clear shopping cart after it Confirmation page has been shown
    session[:order_id] = nil
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # must change database
  # flash notices do not workx
  def create
    @order = Order.new(order_params)
    # @order.status = "Pending"
    if @order.save
      @order.place_order
      flash[:success] = 'Order was successfully created.'
      redirect_to order_path(@order.id)
    else
      flash.now[:warning] = 'Order not created'

      @order.errors.messages.each do |field, msg|
        flash.now[field] = messages
        end

      render :new
    end
  end


  # PATCH/PUT /orders/1
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /orders/1

  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def order_params
    params.require(:order).permit(:status, :cust_name, :cust_email, :mailing_address, :cc_name, :cc_digit, :cc_expiration, :cc_cvv, :cc_zip, :user_id)
  end

  def check_status
    Order.check_order_status(@order)
  end
end
