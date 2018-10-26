class SessionsController < ApplicationController

  def create
    auth_hash = request.env['omniauth.auth']
    merchant = Merchant.find_by(uid: auth_hash[:uid], provider: 'github')

    if merchant
      # User was found in the database
      flash[:status] = "success"
      flash[:result_text] = "Logged in as returning merchant #{merchant.username}"

    else
      # User doesn't match anything in the DB
      # Attempt to create a new user
      merchant = Merchant.build_from_github(auth_hash)

      if merchant.save
        flash[:status] = "success"
        flash[:result_text] = "Logged in as new merchant #{merchant.username}"
        # flash[:messages] = merchant.errors.messages

      else
        # Couldn't save the user for some reason. If we
        # hit this it probably means there's a bug with the
        # way we've configured GitHub. Our strategy will
        # be to display error messages to make future
        # debugging easier.
        flash[:status] = "failure"
        flash[:result_text] = "Could not create new merchant account: #{merchant.errors.messages}"
        flash[:messages] = merchant.errors.messages

        redirect_to root_path
        return
      end
    end

    # If we get here, we have a valid user instance
    session[:merchant_id] = merchant.id
    redirect_to root_path
  end

  def destroy
    session.delete(:merchant_id)
    flash[:status] = "success"
    flash[:result_text] = "Successfully logged out!"

    redirect_to root_path
  end
end
