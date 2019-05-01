class UsersController < ApplicationController
  skip_before_action :require_login, only: [:create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authorized?, only: :show
  # GET /users/1
  def show
    render_404 unless @user
    @products = Product.where(user_id: @user)
  end

  # GET /users/new
  # def new
  #   @user = User.new
  # end
  #
  # # GET /users/1/edit
  # def edit
  # end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save # save returns true if the database insert succeeds
      flash[:success] = 'user Created!'

      redirect_to root_path
    else # save failed :(
      flash.now[:danger] = 'user not created!'

      # render :new, status: :bad_request# show the new book form view again
    end
  end



  private

    # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end


  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:uid, :username, :email, :id)
  end

  def authorized?
    @user = User.find_by(id: params[:id])
    if @user.nil?
      flash[:warning] = "Unauthorized"
      redirect_to root_path
    elsif @user.id != session[:user_id]
      flash[:warning] = "You may only view your own account."
      redirect_to user_path(session[:user_id])
    end
  end
end
