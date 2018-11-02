class UsersController < ApplicationController
  before_action :check_permissions, only: [:show, :edit, :destroy, :merchant_dash]

  def index
    @merchants = Merchant.all #adding merchants to index for viewing and sorting in views
    # @users = User.all
  end

  def show; end #TODO change this to be just user profile and create custom route for merchant shopping

  def update
    if @current_user && @current_user.update(user_params)
      flash[:success] = "Saved"
      redirect_to edit_user_path(@current_user.id)
    else
      flash.now[:warning] = 'Please fill in all fields.'
      render :edit, status: :bad_request
    end
  end

  def edit; end

  def destroy
    unless @current_user.nil?
      if @current_user.is_a_merchant? && @current_user.products.any?
        @current_user.products.each do |product|
          product.status = false
          product.save
        end
      end

      @current_user.update(name: "Deleted User", email: nil, address: nil, cc_num: nil, cc_exp: nil, bill_zip: nil, cc_csv: nil, status: "inactive", uid: 0, provider: "none")

      flash[:success] = "#{@current_user.name}'s information deleted"
      redirect_to root_path
    end
  end

  def merchant_dash
    unless @current_user.is_a_merchant?
      flash.now[:warning] = 'Not allowed.'
      render :forbidden
    end
  end

  private

    def check_permissions
      if params[:id].to_i != session[:user_id]
        flash.now[:error] = 'Not allowed.'
        render :forbidden
      end
    end

    def user_params
      allowed_params = :name, :address, :email, :cc_num, :cc_csv, :cc_exp, :type, :bill_zip
      unless @current_user.class == Merchant
        params.require(:user).permit(allowed_params)
      else
        params.require(:merchant).permit(allowed_params)
      end
    end
end
