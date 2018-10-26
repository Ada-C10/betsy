class ProductsController < ApplicationController
  before_action :require_login, only: [:new, :create]
  before_action :find_product, only: [:show, :edit, :update]

  def index
    if params[:merchant_id]
      merchant = Merchant.find_by(id: params[:merchant_id])
      @products = merchant.products

    elsif params[:category_id]
      category = Category.find_by(id: params[:category_id])
      @products = category.products
    else
      @products = Product.all
    end
  end

  def new
    @product = Product.new
    @product.photo_url = ""
  end

  def create
    if @login_user
      # merchant_id = @login_user.id
      # @login_user = @merchant.product.id
      params = product_params

      params[:price] = params[:price].to_f * 100
      params[:merchant_id] = @login_user.id
      params[:photo_url] = "https://i.imgur.com/lbztpnF.jpg" if params[:photo_url].empty?

      @product = Product.new(params)
      # @product.price = @product.price_float_to_int
      # @product.merchant_id = @login_user.id
      # @product.photo_url = "https://i.imgur.com/lbztpnF.jpg" if @product.photo_url.empty?


      if @product.save
        flash[:status] = :success
        flash[:result_text] = "Successfully created
        #{@product.name}"
        redirect_to product_path(@product)
        # debugger
      else
        flash[:status] = :failure
        flash[:result_text] = "Experiencing an issue with order #{@product.id}."
        flash[:messages] = @product.errors.messages
        render :new
      end
    end


    if !@login_user
      flash[:status] = :failure
      flash[:result_text] = "Could not create #{@product}"
      # flash[:messages] = @product.errors.messages
      redirect_to root_path
    end
    # debugger
  end

  def show;
    @avg_rating = self.get_average_rating()
  end

  def edit
    @product = Product.find_by(id: params[:id])

  end

  def update
    if @login_user

      params = product_params

      params[:price] = params[:price].to_f * 100

      @product.update(params)

      result = @product.save

      if result
        flash[:status] = :success
        flash[:result_text] = "Successfully updated product #{@product.name}"
        redirect_to product_path(@product.id)
      else
        flash[:status] = :failure
        flash[:result_text] = "Failed to update"
        flash[:messages] = @product.errors.messages
        render :edit, status: :bad_request
      end
    else
      redirect_back fallback_location: root_path, status: :bad_request

    end
  end

  # shipped toggle method - onced checked, the status should chacnge from true to false ship to shipped

  # def toggle_enable_status
  #
  # end

  def destroy
    if @login_user

      product = Product.find_by(id: params[:id])

      product.destroy

      flash[:status] = :success
      flash[:result_text] = "Successfully deleted product #{product.name}"
      redirect_to merchant_path(@login_user)
    end
  end


  def add_to_order
    @order_item = OrderItem.new
    #(order_id: @current_cart.id, product_id: product.id, quantity: params[:order_items][:inventory], status: 'pending')
    if @order_item.save
      # product.inventory -= params[:order_products][:inventory].to_i
      # product.save
      flash[:status] = :success
      flash[:result_text] = "Successfully added product to cart"
      redirect_to product_path(@product.id)
    else
      flash[:status] = :failure
      flash[:result_text] = "Failed to add to cart"
      # render :show
    end
  end

  def get_average_rating
    reviews = Review.where(product_id: @product.id)
    sum = 0

    reviews.each do |review|
      unless review.star_rating == nil
        sum = sum + review.star_rating
      end
    end

    length = reviews.length

    if length == 0
      return 0
    end

    average = sum / length
    return average
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :description, :photo_url, :status, :inventory, category_ids: [])
  end

  def find_product
    @product = Product.find_by(id: params[:id])
    head :not_found unless @product
  end
end
