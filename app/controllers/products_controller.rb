class ProductsController < ApplicationController
  before_action :find_product, only: [:show]
  skip_before_action :require_login, only: [:index,:show]

  def root
  end

  def index
    @products = Product.all.order(:name)
  end

  def show; end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to root_path
    else
      render :new
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

    render_404 unless @product
    #add flash messages + redirect
  end

  def product_params
    params.require(:product).permit(:name, :cost, :image_url, :inventory, :description, :active)
  end
end
