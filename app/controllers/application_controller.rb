class ApplicationController < ActionController::Base
  before_action :require_login

    def current_user
      @current_user ||= Merchant.find(session[:user_id]) if session[:user_id]
    end

    def require_login
      if current_user.nil?
        flash.now[:error] = "You must be logged in to view this section"
        # render :notfound
        # needs to fix
      end
    end

end
