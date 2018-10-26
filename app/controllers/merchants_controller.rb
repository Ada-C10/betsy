class MerchantsController < ApplicationController
  # QUESTION: WHY ISN'T THIS WORKING????!?!?!
  # skip_before_action :matching_merchant, only: [:index]
  before_action :matching_merchant, only: [:show, :order_summary]

  def index
    @merchant = Merchant.all
  end

  def show
    # QUESTION: add if/else so only login_user can view merchant account page??
    @merchant = Merchant.find(params[:id])
    render_404 unless @merchant
  end

  def order_summary
    # show orders that belong only to merchant
    @orders = Order.joins(:products).where(products: {merchant_id: params[:merchant_id]})

    # show order_items that belong only to merchant
    @order_items = @orders.map { |order| order.order_items }.flatten
  end

  private

  def matching_merchant
    # like, if you're not even logged in, don't try to view such things
    require_login()

    merchant_viewing = Merchant.find_by(id: params[:id])

    # this allows the order summary page to work
    if merchant_viewing.nil?
      merchant_viewing = Merchant.find_by(id: params[:merchant_id])
    end

    if find_merchant != merchant_viewing
      flash[:status] = :failure
      flash[:result_text] = "Only merchant #{merchant_viewing.username} may view this page."

      redirect_to root_path
    end
  end


  def about_us
  end
  

end
