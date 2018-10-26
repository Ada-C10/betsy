class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :retire]
  before_action :require_login, except: [:index, :show, :add_to_cart, :root]

  # before_action :login, except: [:edit, :new] do we want to add this?

  def index
    #pretty sure want to add an if statement to show by category's id but not sure if its connect in the schema correctly
    @products = Product.all.order(:name)
  end
  #@task.update(
  #name: params[:task][:name],
  #description: params[:task][:description],
  #completion_date: params[:task][:completion_date])

  def show; end

  def add_to_cart
    #calling method add_product in model that
    quantity = 1 #if you call this method you get at least one item
    #1 becomes the default so you have at least one order item
    if !params[:quantity].nil? #making sure not nil
      #quantity comes in as a string, to avoid spam comes as 0
      #quantity - checks for positive number greater than one. if you return put
      #-4 you would get -4 but with the .max value it get the biggest number
      #if they don't pass in a number the default is 1
      quantity = [params[:quantity].to_i, quantity].max
    end

    product = Product.find_by(id: params[:product_id].to_i)

    if product.can_purchase?(params[:quantity].to_i)

      @current_order.add_product(params[:product_id], quantity)
      redirect_to products_path
    else
      flash[:danger] = "There is not enought stock to add that quantity to the cart!"
      redirect_to product_path(params[:product_id])
    end
  end

  def new
    @product = Product.new
    @categories = Category.all
    # There should be a merchant to create a new product
    # @merchant should be available via application controller
    if @merchant
      @product.user_id = @merchant.id
    else
      flash.now[:warning] = "That merchant does not exist"
    end
  end

  def edit; end

  def create
    @product = Product.new(product_params)
    @product.categories
    @product.user_id = @current_user.id

    if @product.save
      flash[:success] = 'Product Created!'

      redirect_to dashboard_path(@current_user.id)

    else
      flash.now[:danger] = 'Product not created!'

      render :new, status: :bad_request
    end
  end

  def update
    # params[:product][:category_ids] ||= [] #if category_ids returns nil it will be set to empty array
    if @product && @product.update(product_params)
      redirect_to product_path(@product.id)
    elsif @product && !@product.valid? #the product exists and it was invalid inputs
      render :edit, status: :bad_request
    end
  end

  def destroy
  end



  private

  def find_product
    @product = Product.find_by(id: params[:id].to_i)
    # render_404 unless @product

    if @product.nil?
      flash.now[:danger] = "Cannot find the product #{params[:id]}"
      render :notfound, status: :not_found
    end
  end

  def product_params
    #can i access :category_id? not unless there isa belongs_to
    return params.require(:product).permit(:user_id, :name, :price, :description, :photo, :stock, category_ids:[])
  end

end
