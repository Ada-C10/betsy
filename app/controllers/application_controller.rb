class ApplicationController < ActionController::Base
  before_action :require_login

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def require_login
      if current_user.nil?
        flash[:error] = "You must be logged in to view this section"
        redirect_to session_path
      end
    end

end
