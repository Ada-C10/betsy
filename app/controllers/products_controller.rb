class ProductsController < ApplicationController

  before_action :find_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.where(active: true).paginate(page: params[:page], per_page: 16)
  end

  def show
    @reviews = @product.reviews
    @order_item = OrderItem.new(quantity: 1, status: 'pending')
  end

  def new
    @product = Product.new
  end

  def create
    if session[:user_id]
      @product = Product.new(product_params)
      @product.merchant_id = session[:user_id]

      if @product.save
        flash[:status] = :success
        flash[:result_text] = "Product successfully created."
        redirect_to products_path
      else
        flash.now[:status] = :failure
        flash.now[:result_text] = "Product info invalid. Please try again."
        render :new, status: :bad_request
      end
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Only logged in merchants can create products"
      render :new, status: :bad_request
    end
  end

  def edit
  end

  def update
    if session[:user_id] && (session[:user_id] == @product.merchant_id)
      if @product.update(product_params)
        flash[:status] = :success
        flash[:result_text] = "Product successfully edited."
        redirect_to product_path(@product)
      else
        flash.now[:status] = :failure
        flash.now[:result_text] = "Product info invalid. Please try again."
        render :edit
      end
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Only a logged in merchant may update their product."
      render :edit
    end
  end

  def destroy
    @product.destroy
    flash[:status] = :success
    flash[:result_text] = "Product successfully deleted."
    redirect_to products_path
  end

private

  def product_params
    params.require(:product).permit(
      :name,
      :price,
      :description,
      :photo,
      :stock,
      :active,
      :rating,
      :merchant_id,
      category_ids: [])
  end

  def find_product
    @product = Product.find_by(id: params[:id])
    render_404 unless @product
  end

end
