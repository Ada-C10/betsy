class MerchantsController < ApplicationController

  def account
    @merchant = @logged_in_merchant

    if @merchant.nil?
      head :not_found
    end

  end

  def account_order
    @merchant = @logged_in_merchant

    if @merchant.nil?
      return head :not_found
    end

    @items = @merchant.order_items
  end



  def status_change
    @product = Product.find_by(id: params[:id])

    if @product.status
      @product.update_attribute(:status, false)
    else
      @product.update_attribute(:status, true)
    end

    if @product.save
      redirect_back fallback_location: root_path
    end

  end


  def show
    # @merchant = @logged_in_merchant don't use this one, will not show merchant page to user that is not logged in
    @merchant = Merchant.find_by(id: params[:id])

    if @merchant.nil?
      head :not_found
    end

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


  def destroy
    session[:merchant_id] = nil
    flash[:success] = "Successfully logged out!"
    redirect_to root_path
  end





end
