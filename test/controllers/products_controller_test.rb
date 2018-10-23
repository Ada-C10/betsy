require "test_helper"

describe ProductsController do
  describe "homepage" do
    it "can access the homepage" do
      get home_path
      must_respond_with :success
    end
  end

  describe "index" do
    it "must be valid" do
      products = Product.all
      get products_path
      must_respond_with :success
    end


  end
end
