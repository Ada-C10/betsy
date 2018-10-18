class MerchantsController < ApplicationController

  def index
    @merchants = Merchant.all
  end

  def new
    @merchant = Merchant.new
  end

  def create
  end

  def show
    @merchant = Merchant.find_by(id: params[:id])
  end

  def edit
  end

  def update
  end


end
