class SessionsController < ApplicationController
  # TODO How do we handle a merchant shopping/closing browser
  # coming back as a user (not logged in).
  # Do we merge the carts or do we destroy the old cart

  def login

    auth_hash = request.env['omniauth.auth']

    user = User.find_by(uid: auth_hash[:uid], provider: 'github')

    #

    if user
      # User was found in the database
      flash[:success] = "Logged in as returning user #{user.name}"

    else
      #TODO Reroute to signup - Signup does this stuff
      # User doesn't match anything in the DB
      # Attempt to create a new user
      user = User.build_from_github(auth_hash)
      #
      if user.save
        flash[:success] = "Logged in as new user #{user.name}"

      else
        # Couldn't save the user
        #
        flash[:error] = "Could not create new user account: #{user.errors.messages}"
        redirect_to root_path
        return
      end
    end
    # If we get here, we have a valid user instance
    session[:user_id] = user.id
    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "Successfully logged out!"
    redirect_to root_path
  end

end
