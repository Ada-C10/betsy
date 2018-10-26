require "test_helper"
require 'pry'

describe ProductsController do
  # it "must be a real test" do
  #   flunk "Need real tests"
  # end
  let(:products) { Product.where( status: true) }
  let(:poodr) { products(:poodr) }

  describe "authenticated user is logged in merchant" do
    before do
      login(Merchant.first)
    end
  end

  it "must be valid" do
    product = Product.first
    result = product.valid?
    result.must_equal true
  end

  describe "index" do

    it 'can display all products' do
      get products_path
      must_respond_with :success
    end
  end

  describe "create" do

    it "can create a product" do
      mercury = merchants(:mercury)
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new( mock_auth_hash( mercury ) )
      get auth_callback_path(:github)

      product_hash = {
        product: {
          name: 'Practical Object Oriented Programming in Ruby',
          price: 20,
          description: 'A look at how to design object-oriented systems',
          photo_url: 'test url',
          status: true,
          inventory: 1
        }
      }

      expect {
        post products_path, params: product_hash
      }.must_change 'Product.count', 1

      must_respond_with  :redirect

      expect(Product.last.name).must_equal product_hash[:product][:name]
      expect(Product.last.price).must_equal product_hash[:product][:price]
      expect(Product.last.description).must_equal product_hash[:product][:description]
    end


    it "will not create a product with invalid params" do
      mercury = merchants(:mercury)
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new( mock_auth_hash( mercury ) )
      get auth_callback_path(:github)

      product_hash = {
        product: {
          price: 20,
          description: 'A look at how to design object-oriented systems',
          photo_url: 'test url',
          status: "test string not boolean",
          inventory: 1
        }
      }

      expect {
        post products_path, params: product_hash
      }.wont_change 'Product.count'

      must_respond_with :success

    end
  end

  describe 'update' do

    it 'can update a product if logged in' do

      mercury = merchants(:mercury)
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new( mock_auth_hash( mercury ) )
      get auth_callback_path(:github)


      @login_user = Merchant.first
      product = Product.first

      product_hash = {
        product: {
          name: 'Practical Object Oriented Programming in Ruby',
          price: 20,
          description: 'A look at how to design object-oriented systems',
          photo_url: 'test url',
          status: true,
          inventory: 1
        }
      }

      patch product_path(product.id), params: product_hash
      must_respond_with :found


    end

    it 'will not update a product if not logged in' do
      product = Product.first
      product_hash = {
        product: {
          name: 'Practical Object Oriented Programming in Ruby',
          price: 20,
          description: 'A look at how to design object-oriented systems',
          photo_url: 'test url',
          status: true,
          inventory: 1
        }
      }

      patch product_path(product.id), params: product_hash
      must_respond_with :bad_request


    end
  end

  describe 'show' do

      it 'can display a product details page' do
        product = Product.first

        get product_path(product.id)
        must_respond_with :success
      end

      it 'returns not found if invalid id' do

        get product_path(0)
        must_respond_with :not_found
      end

  end

  describe 'update' do

      it 'a logged in user can update a product' do

        mercury = merchants(:mercury)
        OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new( mock_auth_hash( mercury ) )
        get auth_callback_path(:github)

        @login_user = Merchant.first

        product = Product.find_by(name: 'Poodr')

        put merchant_product_path(mercury.id, product.id), params {
        product_hash = {
          product: {
            name: 'top poodr',
            price: 20,
            description: 'A look at how to design object-oriented systems',
            photo_url: 'test url',
            status: true,
            inventory: 1
          }
        }
      }

        product_update = Product.find_by(name: 'top poodr')

        product_update.name.must_equal 'top poodr'
        must_respond_with :redirect
        must_redirect_to product_path(@product.id)

      end

      it 'it falls back to root path and sends bad request if not logged in' do
        product = Product.first
        product_hash = {
          product: {
            name: 'Practical Object Oriented Programming in Ruby',
            price: 20,
            description: 'A look at how to design object-oriented systems',
            photo_url: 'test url',
            status: true,
            inventory: 1
          }
        }

        patch product_path(product.id), params: product_hash
        must_respond_with :bad_request

      end
  end

  describe 'destroy' do

      it "a merchant can destroy their own product" do
        product = Product.find_by(name: 'houseplant')
        @login_user = Merchant.find(product.merchant.id)

        OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new( mock_auth_hash( @login_user ) )
        get auth_callback_path(:github)

        expect {
          delete product_path(product.id)
        }.must_change('Product.count', -1)

        must_respond_with :redirect
        must_redirect_to merchant_path(@login_user.id)


    end
  end

  describe 'add_to_order' do

      it 'a product can be successfully added to the cart' do
        product = Product.first
        product_data = {
                  name: 'test',
                  product_id: product.id,
                  merchant_id: Merchant.first.id
                }

        current_count = Product.count

        get add_to_order_path(product.id)

        must_respond_with :redirect
        must_redirect_to product_path(product.id)
      end



      it 'a product can have an average rating' do

      end
    end
end
