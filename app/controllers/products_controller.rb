class ProductsController < ApplicationController
  before_action :find_product, only: [:show]

  def root
  end

  def index
    @products = Product.all.order(:name)
  end

  def show; end

  def new
  end

  def create
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
