class MerchantsController < ApplicationController
  before_action :find_merchant, only: [:show]
  def index
    @merchants = Merchant.all.order(:name)
  end

  def show
    @products = @merchant.products
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

  private
  def find_merchant
    @merchant = Merchant.find_by(id: params[:id])

    render_404 unless @merchant
    #add flash messages + redirect
  end

  def merchant_params
    params.require(:merchant).permit(:name, :email, :avatar_url, :uid, :provider)
  end
end
