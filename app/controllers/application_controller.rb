class ApplicationController < ActionController::Base
  before_action :find_home_category

  private
  
  def find_home_category
    all_categories = Category.all

    @categories = []

    all_categories.each do |c|
      @categories << c
    end

  end

end
