class SessionsController < ApplicationController

  def create
    auth_hash = request.env['omniauth.auth']

    current_user = User.find_by(uid: auth_hash[:uid], provider: 'github')

    if current_user
      # session[:user_id] = current_user.id
      flash[:success] = "Welcome back #{current_user.name}!"
      redirect_to merchant_dash_path(current_user.id)
    else
      #try to make a new user
      current_user = User.build_from_github(auth_hash)
      current_user.type = "Merchant"

      if current_user.save
        flash[:success] = "Welcome #{current_user.name}!"
        redirect_to edit_user_path(current_user.id)
      else
        flash[:warning] = "Could not create account: #{current_user.errors.messages}"
        redirect_to root_path
        return
      end
    end

    session[:user_id] = current_user.id
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "Bye!"
    redirect_to root_path
  end
end
