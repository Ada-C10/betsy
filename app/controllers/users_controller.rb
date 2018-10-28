class UsersController < ApplicationController
  before_action :find_user, only: [:show]

  def index
    @users = User.all
  end

  def show
    render :notfound, status: :not_found unless @user
  end

end
