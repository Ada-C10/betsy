class MerchantsController < ApplicationController
  before_action :find_merchant, only: [:show]

  def index
    @merchants = Merchant.all.order(:name)
  end

  def show
    @orderitem = Orderitem.new
    @products = @merchant.products
  end

  def account
    @merchant = @current_user
    @products = @merchant.products
  end

  private
  def find_merchant
    @merchant = Merchant.find_by(id: params[:id].to_i)

    unless @merchant
      render "layouts/notfound", status: :not_found
    end
  end

  def merchant_params
    params.require(:merchant).permit(:name, :email, :avatar_url, :uid, :provider)
  end
end
