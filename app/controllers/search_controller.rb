class SearchController < ApplicationController
  skip_before_action :require_login

  def search
    @term = params[:search]
    if @term == ""
      @products = []
    else
      @products = Product.text_search(params[:search]).where(active: true)
    end
    @merchants = Merchant.text_search(params[:search])
    @categories = Category.text_search(params[:search])
    @sum = @products.length + @merchants.length + @categories.length
    @orderitem = Orderitem.new
  end

  def find_order
    order_id = params[:id].to_i
    email = params[:email]

    @order = Order.find_by(id: order_id)

    if @order.nil?
      flash[:status] = :failure
      flash[:result_text] = "Could not find order."
      redirect_to root_path
    elsif @order && @order.email == email
      redirect_to order_path(order_id)
    else
      flash[:status] = :failure
      flash[:result_text] = "Email does not match order number."
      redirect_to root_path
    end
  end
end
