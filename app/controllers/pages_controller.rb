class PagesController < ApplicationController
  skip_before_action :require_login
  def home
    @products = Product.all.order(:name).where(active: true).where("inventory > ?", 0)
  end
end
