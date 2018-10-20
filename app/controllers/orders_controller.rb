class OrdersController < ApplicationController
  skip_before_action :require_login, only: [:show]

  def index
  end

  def show
    @order = Order.find_by(id: params[:id])
    unless @order
      render "layouts/notfound", status: :not_found
    else
      @orderitems = @order.orderitems.order(created_at: :desc)
    end
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
