class OrderitemsController < ApplicationController
  def index
  end

  def show
  end

  def new
  end

  def create
    @orderitem = Orderitem.new(orderitem_params)
    @orderitem.product_id =
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def orderitem_params
    params.require(:orderitem).permit(:quantity, :product_id)
  end
end
