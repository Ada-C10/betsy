class MerchantsController < ApplicationController

  before_action :find_merchant, only: [:show, :dashboard]

  def index
    @merchants = Merchant.all
  end

  def show
  end

  def dashboard
  end

private

  def merchant_params
   return params.require(:merchant).permit(
      :username,
      :email,
      :uid,
      :provider
    )
  end

  def find_merchant
    @merchant = Merchant.find_by(id: params[:id])
    render_404 unless @merchant
  end

end
