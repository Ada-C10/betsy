class ItemsController < ApplicationController
  before_action :find_searched_item, only: [:show, :edit, :update, :destroy, :find_item_category]
  before_action :find_item_category, only: [:show]

  def index
    @items = Item.all
  end

  def edit
  end

  def new
    @item = Item.new()
  end

  def create
    # @item = Item.new(user_id: @current_user.id)
    @item = Item.new(item_params)

    if @current_user
      @item.user_id = @current_user.id
    end

    save_success = @item.save

    if save_success
      flash[:success] = "Item #{@item.name} successfully saved."
      redirect_to shop_path
    else
      flash.now[:error] =  "Item was not saved."
      render :new, status: :bad_request
    end
  end

  def destroy
    in_order = OrderItem.find_by(item_id: @item.id)


    if in_order
      flash[:error] = "Item cannot be deleted. There is a pending order with this item"
      # redirect_back (fallback_location: root_path)
      redirect_back(fallback_location: root_path)
    else
      success = @item.destroy
      flash[:success] = "Item successfully deleted."
      redirect_back(fallback_location: root_path)
    end
  end


  def show
    head :not_found unless @item
    @order = Order.find_by(id: session[:order_id])
  end

  def update
  success_save = @item.update(item_params)

    if success_save
      flash[:success] = "Item successfully updated."
      redirect_to shop_path
    else
      flash.now[:error] =  "Error in updating product"
      render :edit, status: 400
    end
  end

  private

  def item_params
    return params.require(:item).permit(
      :name,
      :category_id,
      :price,
      :quantity_available,
      :description,
      :image,
      :active
    )
  end

  def find_searched_item
    @item = Item.find_by(id: params[:id])
  end

  def find_item_category
    @item_category = Category.find(@item.category_id).category_type
  end
end
