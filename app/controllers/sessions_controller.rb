class SessionsController < ApplicationController
  before_action :find_product, only: [:add_to_cart, :update_quantity, :remove_from_cart]

  def create
    auth_hash = request.env['omniauth.auth']

    user = User.find_by(uid: auth_hash[:uid], provider: 'github') ||
      User.create_from_github(auth_hash)

    if user.save
      flash[:success] = "Logged in as returning user #{user.name}"
      session[:user_id] = user.id
      redirect_to root_path
    else
      flash[:danger] = "Could not create new user account: #{user.errors.messages}. Check github email and name please"
      redirect_back fallback_location: root_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = 'Successfully logged out'
    redirect_back fallback_location: root_path
  end

  def add_to_cart
    id = @product.id.to_i
    quantity = params[:quantity].to_i
    # session[:cart] = nil
    item = false
    if [*1..@product.stock_count].include? (quantity)
      session[:cart].each.with_index do |hash, index|
        hash.each do |key, value|
          if key == id.to_s
            item = true
            new_quantity = value + quantity
            if new_quantity <= @product.stock_count
              session[:cart][index][key] = value + quantity
              flash[:success] = "Added to basket"
            else
              flash[:warning] = "Failure to add to basket. Not enough creatures available."
            end
          end
        end
      end
      if item == false
        session[:cart] << { id => quantity}
        flash[:success] = "Added to basket"
      end
    else
      flash[:warning] = "Failure to add to basket. Not enough creatures available."
    end
    redirect_back(fallback_location: root_path)
  end

  def cart_view
    @cart_items = []
    session[:cart].each.with_index do |hash|
      hash.each do |key, value|
        cart_product = Product.find_by(id: key.to_i)
        @cart_items << [cart_product, value]
      end
    end
    render :cart
  end

  def update_quantity
    id = @product.id.to_i
    quantity = params[:quantity].to_i
    if [*1..@product.stock_count].include? (quantity)
      session[:cart].each.with_index do |hash, index|
        hash.each do |key, value|
          if key == id.to_s
            session[:cart][index][key] = quantity
            flash[:success] = "Successfully updated basket."
          end
        end
      end
    else
      flash[:warning] = "Failure to add to basket. Invalid availability."
    end
    redirect_to cart_path
  end

  def remove_from_cart
    id = @product.id.to_i
    session[:cart].each.with_index do |hash, index|
      hash.each do |key, value|
        if key == id.to_s
          session[:cart].delete_at(index)
          flash[:success] = "Successfully removed from basket."
          redirect_back(fallback_location: root_path)
        end
      end
    end
  end

  private

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
