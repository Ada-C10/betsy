class SessionsController < ApplicationController
  def create
    auth_hash = request.env['omniauth.auth']

    merchant = Merchant.find_by(uid: auth_hash[:uid], provider: auth_hash[:provider])

    if merchant
      flash[:status] = :success
      flash[:result_text] = "Welcome #{merchant.username}"
    else
      merchant = Merchant.create_from_github(auth_hash)

      if merchant.save
        flash[:status] = :success
        flash[:result_text] = "Logged in as merchant #{merchant.username}"
      else
        flash[:status] = :failure
        flash[:result_text] = "Could not create new account: #{merchant.errors.messages}"
        redirect_to root_path
        return
      end
    end

    session[:user_id] = merchant.id
    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    flash[:status] = :success
    flash[:result_text] = "Successfully logged out"
    redirect_to root_path
  end
end
