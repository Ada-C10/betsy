class HomepageController < ApplicationController
  def index
    @newest = Item.order(created_at: :desc).take(5)
  end
end
