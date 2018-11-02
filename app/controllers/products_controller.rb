class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :retire]
  before_action :find_merchant, only: [:edit, :update, :retire, :new, :create]

  def index
    @products = Product.active_products
  end

  def bycategory
    id = params[:id].to_i
    @category_selected = Category.find_by(id:id)
    if @category_selected
      @products_by_category = Product.category_list(id)
    else
      render :notfound, status: :not_found
    end
  end

  def bymerchant
    id = params[:id].to_i
    @merchant_selected = User.find_by(id:id)
    if @merchant_selected
      @products_by_merchant = Product.merchant_list(id)
    else
      render :notfound, status: :not_found
    end
  end

  def show
    if @product.status == false ||@product.nil?
      render :notfound, status: :not_found
    end
    if @current_order.valid?
      @op = @current_order.order_products.find_by(product_id: params[:id])
    end
  end

  def new
    if session[:user_id] && @current_user.is_a_merchant?
        @product = Product.new

    end
  end

  def create

    if @current_user.is_a_merchant?

      @product = @current_user.products.new(product_params)

        category_ids = params[:product][:category_ids].select(&:present?).map(&:to_i)
        category_ids.each do |id|
          c = Category.find(id)
          @product.categories << c
        end

      if @product.save
        flash[:success] = 'Product Created!'
        redirect_to product_path(id: @product.id)
      else
        flash.now[:warning] = 'Product not created!'
        render :new, status: :bad_request
      end
    else
      flash.now[:warning] = 'Not a Merchant!'
    end
  end



  def edit; end

  def update
    if @product && @product.update(product_params)
      @product.categories = []
      category_ids = params[:product][:category_ids].select(&:present?).map(&:to_i)
      category_ids.each do |id|
        c = Category.find(id)
        @product.categories << c
      end

      redirect_to product_path(@product[:id])
    elsif @product
      render :edit, status: :bad_request
    end
  end

  def retire

      @product.status = false
      if @product.save
         flash[:success] = "#{@product.name} retired"
         redirect_to products_path
      else
         lash[:warning] = "#{@product.name} is not retired"
      end

  end




  private
  def find_product

    @product = Product.find_by(id: params[:id].to_i)

    if @product.nil?
      flash.now[:warning] = "Cannot find the product #{params[:id]}"
      render :notfound, status: :not_found
    end
  end

  def find_merchant
    @merchant = Merchant.find_by(id: session[:user_id].to_i)
    if @merchant.nil?
      flash.now[:warning] = "Cannot find the merchant #{session[:user_id]}"
      render :notfound, status: :not_found
    end
  end

  def product_params
    return params.require(:product).permit(:name, :price, :description, :stock, :photo_url).except(:category_ids)
  end

  def category_params
    return params.require(:category).permit(:id)
  end

  def review_params
    return params.require(:review).permit(:name, :rating, :comment)
  end

  def render_404
    raise ActionController::RoutingError.new('Not Found')
  end
end
