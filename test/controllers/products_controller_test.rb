require "test_helper"
require 'pry'

describe ProductsController do
  let(:product) { products(:shirt) }
  let(:product2) {products(:dress)}
  let(:user) { users(:user1) }
    let(:cc_user) { users(:cc_user) }
    let(:cc_merchant) { merchants(:cc_merchant) }
    let(:merchant) { merchants(:merchant) }
  let(:category1) {categories(:category1)}
  let(:category2) {categories(:category2)}


  it "should get index" do
    get products_path

    must_respond_with :success
  end

  describe "show" do
    it "should get a product's show page" do
      # Arrange
      id = products(:shirt).id

      # Act
      get product_path(id)

      # Assert
      must_respond_with :success
    end

    it "should respond with not_found if given an invalid id" do
      # Arrange - invalid id
      id = -1

      # Act
      get product_path(id)

      # Assert
      must_respond_with :not_found
    end
  end

  describe "bycategory" do
    it "should get the bycategory page for valid category id" do
      # Arrange
      id = category1.id

      # Act
      get bycategory_path(id)

      # Assert
      must_respond_with :success
    end

    it "should respond with not_found if given an invalid id" do
      # Arrange - invalid id
      id = -1

      # Act
        get bycategory_path(id)

      # Assert
      must_respond_with :not_found
    end
  end

  describe "bymerchant" do
    it "should get the bymerchant page for valid merchant id" do
      # Arrange
      id = cc_user.id

      # Act
      get bymerchant_path(id)

      # Assert
      must_respond_with :success
    end

    it "should respond with not_found if given an invalid id" do
      # Arrange - invalid id
      id = -1

      # Act
        get bymerchant_path(id)

      # Assert
      must_respond_with :not_found
    end
  end




  describe "new" do
    it "can get the new product page" do

      # Act
      get new_product_path

      # Assert

    end

    it "can get the form with the new_product_path with user logged in" do
      # Arrange

      user = users(:cc_user)
      perform_login(user)
      expect(session[:user_id]).wont_be_nil

      id = product.id

      # Act
      get new_product_path(id)
      # Assert
      must_respond_with :success
    end


  end

  describe "edit" do
    it "can get the edit page for a valid product sold by a logged in merchant" do
      # Arrange
      id = product.id
      product.user = cc_user
      perform_login(cc_user)
      # Act
      get edit_product_path(id)

      # Assert
      must_respond_with :success
    end

    it "cannot  get the edit page for a valid product not sold by a logged in merchant" do
      # Arrange
      id = product.id

      perform_login(cc_user)
      # Act
      expect{get edit_product_path(id)}

      # Assert

    end

    it "should respond with not_found if given an invalid id" do
      # Arrange - invalid id
      id = -1

      # Act
      get edit_product_path(id)

      # Assert
      expect(response).must_be :not_found?
      must_respond_with :not_found
      expect(flash[:warning]).must_equal "Cannot find the product -1"
    end

    # not log in user cannot edit

    # log in user can edit own

    # logn in user cannot edit others

    # display not found for invalid post id..


  end

  describe "retire" do
    it "can retire a product by the logged merchant who created the product" do
      # Arrange
      id = product.id
      name = product.id

      perform_login(cc_user)
      product.user = cc_user

      # Act - Assert
      expect {
        patch retire_path(id)
      }.must_change 'Product.active_products.count', -1

      must_respond_with :redirect
      must_redirect_to products_path
      expect(flash[:success]).must_equal "#{product.name} retired"
      expect(Product.find_by(id: id).status).must_equal false
    end

    it "should respond with not_found for an invalid product id" do
      id = -1

      expect {
        patch product_path(id)
        # }.must_change 'Book.count', 0
      }.wont_change 'Product.active_products.count'

      must_respond_with :not_found
      expect(flash.now[:warning]).must_equal "Cannot find the product #{id}"
    end

    # it "should respond with not_found for a user not logged in" do
    #
    # end
  end

  describe "create & update" do


    let (:product_hash) do
      {
        product: {
          name: 'White Teeth',
          user_id: cc_merchant.id,
          price: 10,
          stock: 5,
          description: 'Good book',
          category_ids: [category1.id]
        }
      }


    end


    describe "create" do
      it "can create a new product given valid params by logged in merchant" do
        # Act-Assert
      merchant = merchants(:cc_merchant)
  # Make fake session
  # Tell OmniAuth to use this user's info when it sees
 # an auth callback from github
       OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(merchant))
       get auth_callback_path('github')


        expect {
          post products_path, params: product_hash
        }.must_change 'Product.count', 1


        must_respond_with :redirect

        expect(Product.last.name).must_equal product_hash[:product][:name]
        expect(Product.last.user).must_equal merchant

        expect(Product.last.stock).must_equal product_hash[:product][:stock]
        expect(Product.last.price).must_equal product_hash[:product][:price]
      end

      it "responds with an error for invalid params" do
        # Arranges
        merchant = merchants(:cc_merchant)

        OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(merchant))
        get auth_callback_path('github')
        product_hash[:product][:name] = nil

        # Act-Assert
        expect {
          post products_path, params: product_hash
        }.wont_change 'Product.count'

        must_respond_with :bad_request

      end
    end

    describe "update" do
      let (:update_hash) do
        {
          product: {
            name: 'White Teeth',
            user_id: merchant.id,
            price: 10,
            stock: 5,
            description: 'Good book',
            category_ids: [category1.id]
          }
        }
      end


      it "can update a product with valid params by logged in user" do

        merchant = merchants(:merchant)

        OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(merchant))
        get auth_callback_path('github')

        id = product.id

        expect {
          patch product_path(id), params: update_hash
        }.wont_change 'Product.count'


        must_respond_with :redirect
        must_redirect_to product_path(id)

        new_product= Product.find_by(id: id)

        expect(new_product.name).must_equal product_hash[:product][:name]
        expect(new_product.user).must_equal merchant
        expect(new_product.stock).must_equal product_hash[:product][:stock]
        expect(new_product.price).must_equal product_hash[:product][:price]
      end
      it "gives an error if the product params are invalid" do
        # Arrange
        product_hash[:product][:name] = nil
        merchant = merchants(:merchant)


        OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(merchant))
        get auth_callback_path('github')

        id = product.id


        expect {
          patch product_path(id), params: product_hash
        }.wont_change 'Product.count'
        new_product = Product.find(id)

        must_respond_with :bad_request
        expect(product.name).must_equal new_product.name
        expect(product.user).must_equal merchant
        expect(product.price).must_equal new_product.price
        expect(product.stock).must_equal new_product.stock
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
