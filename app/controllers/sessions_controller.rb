class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:create]

  def create
    auth_hash = request.env['omniauth.auth']

    merchant = Merchant.find_by(uid: auth_hash[:uid], provider: 'github')

    if merchant
      # flash[:status] = :success
      # flash[:result_text] = "Logged in as returning user #{merchant.name}"
    else
      merchant = Merchant.build_from_github(auth_hash)

      if merchant.save
        # flash[:status] = :success
        # flash[:result_text] = "Logged in as new user #{merchant.name}"
      else
        # flash[:status] = :failure
        # flash[:result_text] = "Could not create new user account: #{merchant.errors.messages}"
        # flash.now[:messages] = merchant.errors.messages
        redirect_to root_path
        return
      end
    end

    session[:user_id] = merchant.id
    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    # flash[:status] = :success
    # flash[:result_text] = "Successfully logged out"

    redirect_to root_path
  end
end
