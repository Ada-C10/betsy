class OrdersController < ApplicationController

  def show
    current_order = Order.find_by(id: params[:id])
    # @order_items = @current_order.order_items

    @order_items = OrderItem.where(order_id: current_order.id)
    # @order_items = current_order.order_items
  end

  #fill out order details
  def edit
    @order = Order.find_by(id: params[:id])
  end

  #submit order button
  def update

    @order = Order.find_by(id: params[:id])

    successful = @order.update(parsed_order_data(order_params))

    #to do --> MOVE logic into instance method in Order
    # @order.order_items.each do |order_item|
    #   order_item.submit_order_item
    # end
    @order.submit_order

    if successful
      #clear session data
      temp_id = session[:order_id]
      session[:order_id] = nil
      flash[:success] = "Thank you for your order. Order confirmation number: #{@order.id}. Please save this number to view your order status. Disclaimer: This site is for demonstration purposes only."
      redirect_to status_path(temp_id)
    else

      flash.now[:error] =  "Error in submitting order."
      render :edit, status: 400
    end
  end

  private

  def order_params
    return params.require(:order).permit(
      :name,
      :email,
      :mailing_address,
      :name_on_card,
      :credit_card_num,
      :credit_card_exp_year,
      :credit_card_exp_month,
      :cvv_num,
      :zipcode
    )
  end

  def parsed_order_data(order_params)
    return { name: order_params[:name], email: order_params[:email], mailing_address: order_params[:mailing_address], name_on_card: order_params[:name_on_card], credit_card_num: order_params[:credit_card_num],  credit_card_exp_year: order_params[:credit_card_exp_year], credit_card_exp_month: order_params[:credit_card_exp_month], status: "paid"
    }
  end
end
