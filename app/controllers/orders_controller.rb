class OrdersController < ApplicationController
  before_action :find_order, only: [:edit,:update, :show]

  #
  # def new #WRONG TO HAVE @ORDER
  #   #doesn't exist on the website
  #   #new is created by before action
  #   @order = Order.new
  #   # Find user
  #   # If no user, User.create
  #  if params[:user_id]
  #    @user_id = params[:user_id].to_i
  #    user = User.find_by(id: @user_id)
  #    if user.nil?
  #      flash.now[:warning] = "That user doesn't exit"
  #    end
  #    @order.user_id = @user_id
  #  end
  # end
  # def new
  #   @order = Order.new
  #   # Find user
  #   # If no user, User.create
  #   if params[:user_id]
  #     @user_id = params[:user_id].to_i
  #     user = User.find_by(id: @user_id)
  #     if user.nil?
  #       flash.now[:warning] = "That user doesn't exit"
  #     end
  #     @order.user_id = @user_id
  #   end
  # end




  def update
    if @current_order && @current_order.update(order_params)
      order = Order.find_by(id: @current_order.id, status: "pending")
      order.status = "paid"
      if order.orders_items.nil?
        render :edit, status: :bad_request
      else
        order.orders_items.each do |o_i|
          o_i.product.reduce_stock(o_i.quantity)
          o_i.product.save
          # if !o_i.product.save
          #   redirect_to order_path(@current_order.id)
          # end
        end
        order.save
      end
      flash[:success] = "Order has been placed! Your ORDER CONFIRMATION ##{@current_order.id} "
      redirect_to confirmation_path(@current_order.id) #Redirect to order confirmation
    end
  end

  def show

  end

  def edit
  end

  def index
    @orders = Order.all
  end

  def confirmation
    @confirmed_order = Order.find_by(id: params[:order_id])
    @items_in_cart = @confirmed_order.orders_items
    @revenue_total = @items_in_cart.inject(0) { |sum, item| sum + item.calculate_total }
    @date_placed = @confirmed_order.updated_at
    @order_status = @confirmed_order.status

  end

  private

  def adjust_stock(order)
  end

  def order_params
    return params.require(:order).permit(:status, :street, :city, :state, :zip, :creditcard, :cvv, :billingzip, :ccexpiration, :name, :email, :user_id)
  end

  def find_order
    @order = Order.find_by(id: params[:id].to_i)

    if @order.nil?
      flash.now[:danger] = "Cannot find the order #{params[:id]}"
      render :notfound, status: :not_found
    end
  end

end
