class SessionsController < ApplicationController
  def create
    auth_hash = request.env['omniauth.auth']
    # raise
    user = User.find_by(uid: auth_hash[:uid], provider: auth_hash[:provider])


    if user
      session[:user_id] = user.id
    else
      new_user = User.new(
        name: auth_hash['info']['name'],
        nickname: auth_hash['info']['nickname'],
        email: auth_hash['info']['email'],
        image_url: auth_hash['info']['image'],
        uid: auth_hash['uid'],
        provider: auth_hash['provider'],
        created_at: Time.now
      )

      if new_user.save
        session[:user_id] = new_user.id
        flash[:success] = "Successfully logged in"
      else
        flash[:error] = "Unable to log in"
        redirect_to root_path
        return
      end
    end
    redirect_to root_path

  end

  def logout
    session[:user_id] = nil
    redirect_to root_path
  end
end
