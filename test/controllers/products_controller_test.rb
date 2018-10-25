require "test_helper"
require "pry"

describe ProductsController do

  describe "Logged in merchants" do

    before do
      perform_login(merchants(:bake_off))
    end

    describe "access for logged in merchants" do
      it "logged in merchants can access the homepage" do
        get home_path
        must_respond_with :success
      end

      it "logged in merchants can access the all products index page" do
        products = Product.all
        get products_path
        must_respond_with :success
      end

      it "logged in merchants can access the show page for a product" do
        product_id = Product.first.id
        get product_path(product_id)
        must_respond_with :success
      end

      # I think this failure has something to do with single-use?

      it "logged in merchants cannot access the show page for a product that doesn't exist" do
        product_id = Product.first.id + 1

        get product_path(product_id)
        must_respond_with :not_found
      end

      it "logged in merchants can access the new product form" do
        get new_product_path
        must_respond_with :success
      end
    end

    describe "update-ability for logged-in merchants" do
      describe "create" do
        it "creates a product with valid data" do

          product_data = {
            product: {
              name: "Fuzzy bunnies",
              price: 100,
              inventory: 2,
              merchant_id: 1
            }
          }

          expect {
            post products_path, params: product_data
          }.must_change('Product.count', +1)

          must_redirect_to product_path(Product.last)
        end

        it "will not create a product, given incomplete data" do

          product_data = {
            product: {
              price: 100,
              inventory: 2,
              merchant_id: 1
            }
          }

          expect {
            post products_path, params: product_data
          }.wont_change ('Product.count')

          must_respond_with :bad_request
        end
      end

      describe "edit" do
        it "succeeds for a product ID that exists" do
          get edit_product_path(Product.first)
          must_respond_with :success
        end


        it "renders not_found for product that doesn't exist" do
          product = Product.first
          # order_items = OrderItem.all
          # order_items.destroy_all
          product.destroy

          get edit_product_path (product)
          must_respond_with :not_found
        end
      end

      describe "update" do
        let (:product_hash) {
          {
            product: {
              name: 'Fuzzy Bunnies',
              price: 10,
              inventory: 20,
            }
          }
        }
        it "succeeds for valid data and an extant work ID" do
          product = products(:butter).id
          expect {
            patch product_path(product), params: product_hash
          }.wont_change 'Product.count'

          must_respond_with :redirect

          product = Product.find_by(id: product)
          expect(product.name).must_equal 'Fuzzy Bunnies'
          expect(product.price).must_equal 10
          expect(product.inventory).must_equal 20
        end

        it "renders bad_request for badf data" do
          product = products(:butter).id
          product_hash[:product][:price] = 0
          expect {
            patch product_path(product), params: product_hash
          }.wont_change 'Product.count'

          must_respond_with :bad_request

        end
      end
    end
  end

  describe "Guest users" do
    describe "access for guest users" do
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

      # I think this failure has something to do with single-use
      it "guest users cannot access the show page for a product that doesn't exist" do

        get product_path(Product.last.id + 1)
        must_respond_with :not_found
      end

      it "guest users cannot access the new product form" do
        get new_product_path
        must_redirect_to root_path
        flash[:status].must_equal :failure
      end

      it "guest users cannot access the edit product form" do
        product = Product.first
        get edit_product_path(product)
        must_redirect_to root_path
        flash[:status].must_equal :failure
      end
    end
  end
end
