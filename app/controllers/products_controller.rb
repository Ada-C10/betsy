class ProductsController < ApplicationController

  #only signed in merchants can new, create, edit, update, and destroy

  def homepage

  end

  def index
    @products = Product.all
  end

  def show
    @product = Product.find_by(id: params[:id])
    @order_item = OrderItem.new
    @order_item.product_id = @product.id
    @average_rating = @product.reviews.average(:rating)
    @reviews = @product.reviews
    @review = Review.new

    if @product.nil?
      head :not_found
    end
  end

  def new
    if @logged_in_merchant
      @product = Product.new
    else
      flash[:status] = :failure
      flash[:result_text] = "Sign in as a merchant to access this page."
        redirect_back fallback_location: root_path
    end
  end

  def create
    @product = Product.new(product_params)

    @product.merchant_id = @logged_in_merchant.id

    if @product.save
      flash[:success] = "Congratulations - you successfully entered a new product!"
      redirect_to product_path(@product.id)
    else
      flash.now[:error] = "The data you entered was not valid.  Please try again."
      render :new, status: :bad_request
    end
  end

  def edit
    if @logged_in_merchant
      @product = Product.find_by(id: params[:id])
    else
      flash[:status] = :failure
      flash[:result_text] = "Sign in as a merchant to access this page."
        redirect_back fallback_location: root_path
    end
  end

  def update
    @product = Product.find_by(id: params[:id])
    if @product.update(product_params)
      flash[:success] = "Successfully updated \"#{@product.name}\""
      redirect_to product_path(@product.id)
    else
      flash.now[:error] = "Invalid data"
      render :edit, status: :bad_request
    end
  end

  def destroy
    @product = Product.find_by(id: params[:id])
    if @product.destroy
      flash[:success] = "Successfully deleted \"#{@product.name}\" from the database."
      redirect_to products_path
    else
      redirect_back(fallback_location: products_path)
    end
  end

  private

  def product_params
    return params.require(:product).permit(
      :name,
      :price,
      :description,
      :img_file,
      :merchant_id,
      :inventory,
      category_ids: [],
    )
  end

end
