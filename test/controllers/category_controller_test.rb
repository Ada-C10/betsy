require "test_helper"

describe CategoryController do
  # it "must be a real test" do
  #   flunk "Need real tests"
  # end
  it 'responds with success if the category exists' do
    luggage_category = categories(:luggage)

    get category_path(luggage_category.id)

    must_respond_with :success
  end
end
