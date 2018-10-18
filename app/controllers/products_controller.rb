class ProductsController < ApplicationController
  before_action :find_product, only: [:show]
  skip_before_action :require_login, only: [:index,:show]
  # update as we go with user permissions (this applies to every controller)

  def root
  end

  def index
    @products = Product.all.order(:name)
  end

  def show; end

  def new
    @product = Product.new
    if params[:merchant_id]
      @merchant_id = params[:merchant_id].to_i
      @merchant = Merchant.find_by(id: @merchant_id)
    end
  end

  def create
    if product_params[:merchant_id]
      @product = Product.new(product_params)
      if @product.save
        redirect_to root_path
      else
        render :new, status: :bad_request
      end
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def find_product
    @product = Product.find_by(id: params[:id])

    render :notfound unless @product
    #add flash messages + redirect
  end

  def product_params
    params.require(:product).permit(:name, :cost, :image_url, :inventory, :description, :active, :merchant_id)
  end
end
