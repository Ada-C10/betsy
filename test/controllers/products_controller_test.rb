require "test_helper"

describe ProductsController do
  describe "Logged in users" do

    before do
      perform_login(merchants(:bake_off))
    end

    describe "access" do
      it "logged in users can access the homepage" do
        get home_path
        must_respond_with :success
      end

      it "logged in users can access the all products index page" do
        products = Product.all
        get products_path
        must_respond_with :success
      end

      it "logged in users can access the show page for a product" do
        product_id = Product.first.id
        get product_path(product_id)
        must_respond_with :success
      end

      it "logged in users cannot access the show page for a product that doesn't exist" do
        product_id = Product.first.id + 1

        get product_path(product_id)
        must_respond_with :not_found
      end
    end

  end

  describe "Guest users" do
    describe "access" do
      it "guest users can access the homepage" do
        get home_path
        must_respond_with :success
      end

      it "guest users can access the product index page" do
        products = Product.all
        get products_path
        must_respond_with :success
      end

      it "guest users can access the show page for a product" do
        product_id = Product.first.id
        get product_path(product_id)
        must_respond_with :success
      end

      it "guest users cannot access the show page for a product that doesn't exist" do
        product_id = Product.first.id + 1

        get product_path(product_id)
        must_respond_with :not_found
      end
    end

  end


end
