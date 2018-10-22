require 'pry'
class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :status]
  before_action :find_merchant, only: [:new, :edit, :create]
  skip_before_action :require_login, only: [:index, :show]
  # update as we go with user permissions (this applies to every controller)

  def index
    if params[:merchant_id]
      @merchant = Merchant.find_by(id: params[:merchant_id])
      @products = @merchant.products.order(:name).where(active: true).where("inventory > ?", 0)
    else
      @products = Product.all.order(:name).where(active: true).where("inventory > ?", 0)
    end
  end

  def show
    @orderitem = Orderitem.new
    @review = Review.new
    @reviews = @product.reviews
  end

  def new
    if session[:user_id] == params[:merchant_id].to_i
      @product = Product.new
      @categories = Category.all.order(:name)
    else
      render "layouts/notfound", status: :not_found
    end
  end

  def create
    @categories = Category.all
    if product_params[:merchant_id]
      @product = Product.new(product_params)

      if params[:product][:category]
        @product.categories << Category.create(name: params[:product][:category])
      end

      if @product.save
        flash[:status] = :success
        flash[:result_text] = "Successfully created #{@product.name}"
        redirect_to merchant_path(session[:user_id])
      else
        flash.now[:status] = :failure
        flash.now[:result_text] = "Could not create #{@product.name}"
        flash.now[:messages] = @product.errors.messages
        render :new, status: :bad_request
      end
    end
  end

  def edit
    @categories = Category.all
    if session[:user_id] != params[:merchant_id].to_i
      render "layouts/notfound", status: :not_found
    end
  end

  def update
    if @product.update(product_params)
      @merchant_id = product_params[:merchant_id].to_i
      flash[:status] = :success
      flash[:result_text] = "Successfully updated #{@product.name}"
      redirect_to merchant_path(@merchant_id)
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Could not update #{@product.name}"
      flash.now[:messages] = @product.errors.messages
      render :edit, status: :bad_request
    end

  end

  def status
    if @product.active
      @product.active = false
      if @product.save
        # flash[:status] = :success
        # flash[:result_text] = "Successfully retired #{@product.name}"
        redirect_back(fallback_location: root_path)
      end
    else
      @product.active = true
      if @product.save
        # flash[:status] = :success
        # flash[:result_text] = "Successfully retired #{@product.name}"
        redirect_back(fallback_location: root_path)
      end
    end
  end

  private

  def find_merchant
    if params[:merchant_id]
      @merchant_id = params[:merchant_id].to_i
      @merchant = Merchant.find_by(id: @merchant_id)
    end
  end

  def find_product
    @product = Product.find_by(id: params[:id].to_i)

    if @product.nil?
      render "layouts/notfound", status: :not_found
    end
  end

  def product_params
    params.require(:product).permit(:name, :cost, :image_url, :inventory, :description, :active, :merchant_id, category_ids: [])
  end
end
