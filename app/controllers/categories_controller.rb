class CategoriesController < ApplicationController
  before_action :require_login, except: [:index, :show]
  skip_before_action :require_login, only: [:create]

  def new
    # puts params.to_h
    @category = Category.new
  end

  def create
  end
end
