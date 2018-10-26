require "test_helper"


describe ProductsController do
  it "should get index" do
    get products_path
    must_respond_with :success
  end

  describe "show" do
    it "should get a product's show page" do
      id = products(:product1).id

      get product_path(id)

      must_respond_with :success
    end

    it "should respond with not_found if given an invalid id" do
      id = -1

      get product_path(id)

      must_respond_with :not_found
      expect(flash[:danger]).must_equal "Cannot find the product -1"
    end
  end

  describe "actions that require User Authentication" do

    before do
      user = users(:tom)
      # Make fake session
      # Tell OmniAuth to use this user's info when it sees
     # an auth callback from github
        OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))
        get auth_callback_path('github')
      end

    let (:product_hash) do
      {
        product: {
          name: 'Forbidden Forest',
          price: 8888,
          description: 'scary forest that no one is allowed to go to',
          photo: 'https://images.google.com/',
          stock: 1,
          user_id: users(:tom).id
        }
      }
    end

    describe "edit" do
      it "can get the edit page for a valid product" do
        # Arrange
        id = products(:product1).id

        # Act
        get edit_product_path(id)

        # Assert
        must_respond_with :success
      end

      it "should respond with not_found if given an invalid id" do
        # Arrange - invalid id
        id = -1

        # Act
        get edit_product_path(id)

        # Assert
        expect(response).must_be :not_found?
        must_respond_with :not_found
        expect(flash[:danger]).must_equal "Cannot find the product -1"
      end
    end

    describe "create & update" do


      describe "create" do
        it "can create a new product given valid params" do
          @merchant = users(:tom)
          # Make fake session
          # Tell OmniAuth to use this user's info when it sees
         # an auth callback from github
            OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(@merchant))
            get auth_callback_path('github')

          # Act-Assert
          expect {
            post products_path, params: product_hash
          }.must_change 'Product.count', 1

          must_respond_with :redirect
          must_redirect_to dashboard_path(@merchant.id)  #the last product bc this new one will be added to the end

          expect(Product.last.name).must_equal product_hash[:product][:name]
          expect(Product.last.price).must_equal product_hash[:product][:price]
          expect(Product.last.description).must_equal product_hash[:product][:description]
          expect(Product.last.photo).must_equal product_hash[:product][:photo]
          expect(Product.last.stock).must_equal product_hash[:product][:stock]
          expect(Product.last.user_id).must_equal product_hash[:product][:user_id]

        end

        it "responds with an error for invalid params" do

          # Arranges
          product_hash[:product][:name] = nil

          # Act-Assert
          expect {
            post products_path, params: product_hash

          }.wont_change 'Product.count'

          must_respond_with :bad_request

        end
      end


      describe "update" do
        it "can update a model with valid params" do
          id = products(:product1).id

          expect {
            patch product_path(id), params: product_hash
          }.wont_change 'Product.count'

          must_respond_with :redirect
          must_redirect_to product_path(id)

          new_product = Product.find_by(id: id)

          expect(new_product.name).must_equal product_hash[:product][:name]
          expect(new_product.price).must_equal product_hash[:product][:price]
          expect(new_product.description).must_equal product_hash[:product][:description]
          expect(new_product.photo).must_equal product_hash[:product][:photo]
          expect(new_product.stock).must_equal product_hash[:product][:stock]
          expect(new_product.user_id).must_equal product_hash[:product][:user_id]
        end
        it "gives an error if the product params are invalid" do
          # Arrange
          product_hash[:product][:name] = nil
          id = products(:product1).id
          old_product = products(:product1)


          expect {
            patch product_path(id), params: product_hash
          }.wont_change 'Product.count'
          new_product = Product.find(id)

          must_respond_with :bad_request
          expect(old_product.name).must_equal new_product.name
          expect(old_product.description).must_equal new_product.description
          expect(old_product.photo).must_equal new_product.photo
          expect(old_product.stock).must_equal new_product.stock
          expect(old_product.user_id).must_equal new_product.user_id
        end
        it "gives not_found for a product that doesn't exist" do
          id = -1

          expect {
            patch product_path(id), params: product_hash
          }.wont_change 'Product.count'

          must_respond_with :not_found
        end

      end
    end
  end
    describe "add_to_cart" do
      it "adds a prodcut to an order" do

        # Adding some products
        # Arrange -
        product_one = products(:product1)
        product_two = products(:product2)
        product_three = products(:product3)



        # Act / Assert
        post product_add_to_cart_path(product_one.id)
        post product_add_to_cart_path(product_two.id)
        post product_add_to_cart_path(product_three.id)
        # Current order is nil as there is no session
        # Do we make our own session order?
        current_order = Order.find(session[:order_id])
        current_order.products.length.must_equal 3
        current_order.products.first.must_equal product_one
        current_order.products.all[1].must_equal product_two
        current_order.products.last.must_equal product_three
      end

    # Add some products - run post add_to_cart_path(product.id)


    end

end
