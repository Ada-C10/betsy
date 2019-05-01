class SessionsController < ApplicationController
  skip_before_action :require_login, except: :destroy

  def create
    auth_hash = request.env['omniauth.auth']
    user = User.find_by(uid: auth_hash[:uid], provider: 'github')
    if user
      # User was found in the database
      flash[:success] = "Successfully logged in as #{user.username}"
    else
      # User doesn't match anything in the DB
      user = User.new_user(auth_hash)
      # Attempt to create a new user
      if user.save
        flash[:success] = "Successfully created new user #{user.username} with ID #{user.id}"
      else

        flash.now[:warning] = "Could not log in"
        flash.now[:messages] = user.errors.messages
        render "login", status: :bad_request
        return
      end
    end

    session[:user_id] = user.id
    session[:username] = user.username
    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    @user = nil
    # session.clear
    flash[:notice] = "Goodbye #{session[:username]}!"

    redirect_to root_path
  end
end