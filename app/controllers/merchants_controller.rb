class MerchantsController < ApplicationController
  # add new_product path in the merchant show page ex (# <%= link_to "Add Product", new_product_path %>) add in Products controller: before_action :require_login --also need to add to application controller


  def account
    @merchant = Merchant.find_by(id: params[:id])
  end


  def index
    @merchants = Merchant.all
  end

  def new
    @merchant = Merchant.new
  end

  def create
    merchant_hash = request.env['omniauth.auth']
    merchant = Merchant.find_by(uid: merchant_hash[:uid], provider: merchant_hash[:provider])

    if merchant
      flash[:status] = :success
      flash[:result_text] = "Logged in as returning merchant #{merchant.name}"
    else
      merchant = Merchant.build_from_github(merchant_hash)
      #build_from_github is a method in the merchant model

      if merchant.save
        flash[:status] = :success
        flash[:result_text] = "Successfully logged in as new Merchant #{merchant.name}"
      else
        flash[:status] = :error
        flash[:result_text] = "Could not create new merchant account: #{merchant.errors.messages}"
        redirect_to root_path
        return
      end
    end

    session[:merchant_id] = merchant.id
    redirect_to root_path

  end

  def show
    @merchant = Merchant.find_by(id: params[:id])
  end

  def edit
  end

  def update
  end



  def destroy
    session[:merchant_id] = nil
    flash[:success] = "Successfully logged out!"
    redirect_to root_path
  end

end
