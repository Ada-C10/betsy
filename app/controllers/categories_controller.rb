class CategoriesController < ApplicationController
  skip_before_action :require_login, only: [:index, :show]
  # Need to be logged in to create a new category

  def index
    
  end

  def show
  end

  def new
  end

  def create
  end
end
