require "test_helper"
require 'pry'

describe ProductsController do
  let (:product_data) {
    {
      product: {
        name: "Test product",
        price: 3.50,
        merchant: merchants(:dogdays),
        stock: 5,
        active: true
      }
    }
  }

  let (:product) {
    products(:product_one)
  }

  describe "guest user" do
    describe "index" do
      it "successfully gets index" do
        get products_path

        must_respond_with :success
      end
    end

    describe "show" do
      it "should respond with success for showing an existing product" do

        get product_path(product.id)

        must_respond_with :success
      end

      it "should respond with not found for showing a non-existing product" do

        product.destroy

        expect{
          get product_path(product.id)
        }.must_raise(ActionController::RoutingError)

      end
    end

    describe "create" do
      it 'should not allow guest user to create a new product' do
        test_product = Product.new(product_data[:product])
        test_product.must_be :valid?, "Product data was invalid. Please come fix this test."

        expect {
          post products_path, params: product_data
        }.wont_change('Product.count')

        must_respond_with :bad_request
      end
    end

    describe "update" do
      it "should not allow guest user to update a new product" do

      end
    end
  end

  describe "merchant user" do
    before do
      perform_login(merchants(:dogdays))
    end

    describe "new" do
      it "successfully retrieves new page" do

        get new_product_path

        must_respond_with :success

      end
    end

    describe "create" do
      it "creates new product when logged in and given valid data" do


        test_product = Product.new(product_data[:product])
        test_product.must_be :valid?, "Product data was invalid. Please come fix this test."

        expect {
          post products_path, params: product_data
        }.must_change('Product.count', 1)

        must_redirect_to products_path

        expect(Product.last.name).must_equal product_data[:product][:name]
      end
    end

    describe "edit" do
      it "responds with success for an existing product" do
        get edit_product_path(product)

        must_respond_with :success
      end

      it "responds with not_found for a product that doesn't exist" do
        product.destroy

        expect{
          get edit_product_path(product)

        }.must_raise(ActionController::RoutingError)

      end
    end

    describe "update" do
      it "should show success when showing an existing product" do

        get product_path(product.id)

        must_respond_with :success
      end

      it "should return error message if product doesn't exist" do

        product.destroy

        expect{
          get product_path(product.id)
        }.must_raise(ActionController::RoutingError)

      end
    end

    describe "destroy" do
      it "can destroy an existing product" do


        expect {
          delete product_path(product)
        }.must_change('Product.count', -1)


        must_redirect_to products_path
      end
    end
  end
end
