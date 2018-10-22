class SearchController < ApplicationController
  skip_before_action :require_login, only: [:search]

  def search
    @products = Product.text_search(params[:search])
    @merchants = Merchant.text_search(params[:search])
    @categories = Category.text_search(params[:search])
  end
end
