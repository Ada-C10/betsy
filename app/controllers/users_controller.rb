class UsersController < ApplicationController
  # May need to add edit/update/destroy to this later
  before_action :find_user, only: [:dashboard]
  before_action :require_login, only: [:dashboard]

# Might not need this as login does new oauth
  # def new
  #   @user = User.new
  # end

  def index
    # this works in rails c but not on website...help?
    @merchants = User.all.select { |user| user.uid }
    # Even users says its nil, maybe a seed issue?
    @users = User.all

  end


  def products
    # Show products for the merchant = working
    @merchant = User.find_by(id: params[:user_id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # We run User.create on the checkout page
      # (Merchant creation is done via oauth login)
      flash[:success] = "Account saved!"
      redirect_to root_path
    else
      # Could not save
      flash[:danger] = "Could not save account"
      redirect_to root_path
    end
  end

  #TODO Do we need update? Are we letting merchants edit/update?

# Is a page that shows all merchant's products
# # If person is merchant of that id, can edit products
# Instead of show i'm setting up a product page per merchant


  def products
    # Find merchant id
    # Find products linked to that merchant
    # Show them
    id = params[:user_id].to_i
    @merchant = User.find_by(id: id)

    if @merchant.nil?
      render :notfound, status: :not_found
    end
    @products = @merchant.products.all

  end

  # Requires login to see merchant dashboard
  # Will show products, able to add product, edit product, see orders, etc.
  def dashboard
    # @user = find_user
    #Check if current user is the person for the dashboard view page
    # Is this how that works? Can't test until Github is back up.
    # raise
    if session[:user_id] != params[:id].to_i
      flash[:warning] = "You can only view your own dashboard"
      redirect_to root_path, status: :bad_request
    else

      # @merchant = find_merchant - have this already
      ######## SORT THESE THINGS !!!!
      @products = @merchant.products.sort_by{ |item| item.name }
      if params[:status] && params[:status] != "all"
        @order_items = @merchant.order_items_for_status(params[:status]).sort_by{ |item| item.order_id }
      elsif
        @order_items = @merchant.sold_items.sort_by{ |item| item.order_id }
      end


        order_overview = {}
        @order_items.each do |item|
          # Check if item order number is already in array
          if order_overview[item.order_id]
            order_overview[item.order_id] += 1
          else
            order_overview[item.order_id] = 1
          end
          # if order_numbers.!include?(item.order_id)
          #   # If not, add it
          #   order_numbers << item
          # end
          @total_orders = order_overview.length
          @total_items = order_overview.values.sum
        end
        @revenue_total = @order_items.inject(0) { |sum, item| sum + item.calculate_total }
      # For each product, search for order items
      # Params data - assign to filter - value available in the view - ?
      # Have filter method,
      # Assign filter from params if it exists or user a default or all
      # In partial, use just the filter items ?
      # Links, get some quesries, use them as needed in controller
      # QUERY STRING and Link to
      @status_types = ["pending", "paid", "complete", "cancelled"]

      # TODO - Show summary of orders / revenue
      # @order_itmes = []
      # @order_items = @merchant.products.map do |product|
        #
      # Find order items with product id
      # OrdersItem.select { |item| item.product_id == product.id }
      # Returns array of products, one per order entry
      # Would also need the order for each product.
      # Not sure how this works
      # @order_items << product.orders_items
        # product.orders_items
      # end
    end
    #
    # # How do we find order items for merchant? merchant.orderitems?
    # orderitems.where(merchant_id == @merchant.id) ?
    # @order_items_for_merchant = @merchant.orders_items

  end

  private

# Do I need this or can I just use the find_merchant method?
  def find_user
    # Try to find the user
    @user = User.find_by(id: params[:id].to_i)
    #
    # If user doesn't exist flash a message /render notfound page
    if @user.nil?
      flash.now[:danger] = "Cannot find user"
      #
      render :notfound , status: :not_found
    end
  end

  def user_params

    return params.require(:user).permit(:name, :email, :photo, :uid, :provider)
  end
end
