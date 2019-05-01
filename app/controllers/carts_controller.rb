class CartsController < ApplicationController
  skip_before_action :require_login

  def show
    if @current_order.nil?
      render :not_found, status: :not_found
    else
      @order_items = @current_order.order_items.order(:created_at)
    end
  end

end
