require "test_helper"

describe CategoriesController do
  it "should get index" do
    get categories_index_url
    value(response).must_be :success?
  end

  it "should get new" do
    get categories_new_url
    value(response).must_be :success?
  end

  it "should get create" do
    get categories_create_url
    value(response).must_be :success?
  end

end
