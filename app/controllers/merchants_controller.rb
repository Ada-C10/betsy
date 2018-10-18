class MerchantsController < ApplicationController
  before_action :find_merchant, only: [:show]
  skip_before_action :require_login, only: [:index, :show]

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
    @merchant_id = params[:id].to_i
    @merchant = Merchant.find_by(id: @merchant_id)

    render_404 unless @merchant
  end

  def merchant_params
    params.require(:merchant).permit(:name, :email, :avatar_url, :uid, :provider)
  end
end
