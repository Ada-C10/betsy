class ApplicationController < ActionController::Base
  before_action :find_home_category

  def find_home_category
    @philippines = Category.find_by(name: 'philippines' )

  end

end
