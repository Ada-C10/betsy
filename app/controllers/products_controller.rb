class ProductsController < ApplicationController
  before_action :find_product, except: [:index, :cart_view, :new, :create]
  before_action :require_product_owner, only: [:edit, :update, :destroy]
  #skip_before_action :find_product, only: [:index, :cart_view, :new, :create, :home]
  before_action :require_login, only: [:new]

  def index
    @products = Product.order(:name)
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:success] = "New creature added!"
      redirect_to product_path(@product.id)
    else
      flash.now[:messages] = @product.errors.messages
      render :new, status: :bad_request
    end
  end

  def show;end

  def edit;end

  def update
    @product.update(product_params)
    if @product.save
      flash[:success] = "Successfully updated creature."
      redirect_to product_path(@product)
    else
      render :edit, :status => :bad_request
    end
  end

  private
  def require_product_owner
    if @current_user != @product.user
      flash[:danger] = "Cannot edit another rescuer's creatures"
      redirect_to root_path
    end
  end

  def product_params
    return params.require(:product).permit(:name, :price, :stock_count, :user_id, :photo_url, :description, category_ids: [])
  end

  def find_product
    @product = Product.find_by(id: params[:id])
    if !@product
      @product = Product.find_by(id: params[:product_id])
    end
    if @product.nil?
      render :notfound, status: :not_found
    end
  end

end
