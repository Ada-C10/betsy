class ApplicationController < ActionController::Base
  before_action :find_home_category
  before_action :find_logged_in_merchant

  private

  def find_home_category
    all_categories = Category.all

    @categories = []

    all_categories.each do |c|
      @categories << c
    end
  end



  def find_logged_in_merchant
    @logged_in_merchant = Merchant.find_by(id: session[:merchant_id])
  end


end
