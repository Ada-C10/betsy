class OrdersController < ApplicationController
  before_action :find_order, only: [:show, :edit, :update, :destroy]
  before_action :matching_guest, only: [:show]


  def index

    @orders = Order.find_by(id: session[:order_id])
    # commented out because it's confusong?
    # if session[:merchant]
    #   merchant_id = session[:merchant]['id']
    #   @orders = Merchant.find(merchant_id).orders
    # end

  end

  def new
    @order = Order.new
  end
  # add @order_items
  def show
    # if @order.nil? || !@order.order_items
    #   head :not_found
    # else @order_items = current_order.order_items
    # end

    # @order = Order.find_by(id: params[:id])
    # unless @order
    #   render_404
    # else
    #   merchants = @order.products.map { |p| p.merchant }
    #   if !merchants.include?(matching_guest)
    #     flash[:status] = :failure
    #     flash[:result_text] = "Access denied."
    #     redirect_to root_path
    #   end
    # end
  end

  def create



    # #TODO: translate into strong params
    # @order_item = OrderItem.new(product_id: params[:product_id].to_i, quantity: params[:quantity].to_i, order_id: params[:order_id])
    # # order_id = OrderItem.add_order_item_to_order(@order_item)
    # # @order_item.order_id = order_id
    #
    # # TODO: add if/else or model method to check against + edit product inventory
    #
    # result = @order_item.save
    #
    # if result
    #   flash[:status] = :success
    #   flash[:result_text] = "Successfully created
    #   order item"
    # else
    #   flash[:status] = :failure
    #   flash[:result_text] = "DID NOT create order item #{order_id}"
    #   flash[:messages] = @order_item.errors.messages
    # end
    # redirect_back(fallback_location: root_path)


    # if session[:order_id] ==
    #   @order = Order.new #(params)
    #   @order_category = @order.category
    #   if @order.save
    #     flash[:status] = :success
    #     # flash[:result_text] = "Successfully created order"
    #     # redirect_to
    #   else
    #     flash[:status] = :failure
    #     # flash[:result_text] = "Could not create order"
    #     # flash[:messages] = @order.errors.messages
    #     # render :new, status: :bad_request
    #   end

    # NOTE: <mc> I commented the code below out b/c it threw errors </mc>
    # if sessions[:order_id] ==
    # @order = Order.new #(params)
    # @order_category = @order.category
    #   if @order.save
    #     flash[:status] = :success
    #     # flash[:result_text] = "Successfully created order"
    #     # redirect_to
    #   else
    #     flash[:status] = :failure
    #     # flash[:result_text] = "Could not create order"
    #     # flash[:messages] = @order.errors.messages
    #     # render :new, status: :bad_request
    #   end
    # end

    @order = Order.find_by(id: session[:order_id])

    if @order.nil?
      flash[:status] = :failure
      flash[:result_text] = "No order found"
      flash[:messages] = @order_item.errors.messages
      redirect_to root_path
      return
    end

    @order.update(order_params)

    @order.payment_status = "paid"

    result = @order.save

    if result
      @order.decrement_inventory_via_order()
      set_new_session_order_id()

      flash[:status] = :success
      flash[:result_text] = "Order #{@order.id} successfully paid!"
      render :show
    else
      flash[:status] = :failure
      flash[:result_text] = "Experiencing an issue with order #{@order.id}."
      flash[:messages] = @order.errors.messages
      render :new
    end
  end

  def edit
    if @order.nil?
      head :not_found
    end
  end

  def update
    # if @order.nil?
    #   head :not_found
    # end
    @order.update(order_params)
    if
      @order.update(status: "paid")
      flash.now[:status] = :failure
      flash.now[:result_text] = "Boo!"
      flash.now[:messages] = humanize(@order.errors.messages)
      render :new, status: :bad_request
    end
  end

  def destroy
    if @order.nil?
      head :not_found
    end
    #if @order.destroy
    #redirect_to orders_path
    #else
    #render :show
    #end
  end

  private

  def find_order
    @order = Order.find_by(id: params[:id])
  end

  def order_params
    params.require(:order).permit(:guest_email, :guest_mailing, :guest_cc_name, :guest_cc_num, :guest_cc_exp_date, :guest_cc_cvv_code, :guest_cc_zip)
  end


  # QUESTION: should these be moved to the model?

  # if guest has submitted an order, then we start a new cart tied to a new session id
  def create_new_cart_upon_submit()
    new_order = Order.create()
    return new_order
  end

  def set_new_session_order_id()
    new_order = create_new_cart_upon_submit()
    session[:order_id] = new_order.id
  end

  def matching_guest
    order_viewing = Order.find_by(id: params[:id])

    if find_order.nil? || find_order.id != order_viewing.id
      flash[:status] = :failure
      flash[:result_text] = "Only owner of order #{order_viewing.id} may view this page."

      redirect_to root_path
    end
  end
end
