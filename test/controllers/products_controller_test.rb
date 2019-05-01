require "test_helper"

describe ProductsController do
  let(:product)  { build(:product) }

  it "gets index" do
    get products_url
    value(response).must_be :successful?
  end

  describe "new" do

    it "gets new form for a logged in user" do
      user = users(:laura)
      perform_login(user)

      get new_product_path
      value(response).must_be :successful?
    end

    it "is an invalid request if merchant is not logged in" do
      get new_product_path

      must_redirect_to root_path
      value(response).must_be :redirection?
      expect(flash[:danger]).must_equal "You must log in to access this feature"
    end
  end

  describe "create" do

    it "creates product" do
      user = users(:laura)
      perform_login(user)

      id = users(:laura).id
      product_hash = { product: { prod_name: product.prod_name, description: product.description, price: product.price, inv_qty: product.inv_qty, user: id } }

      expect {
        post products_path, params: product_hash
      }.must_change "Product.count"

      must_redirect_to user_path(session[:user_id])
      expect(flash[:notice]).must_equal "#{product.prod_name} was added to your inventory."
    end

    it "is an forbidden request if user is not logged in" do
      product_hash = { product: { prod_name: product.prod_name, description: product.description, price: product.price, inv_qty: product.inv_qty, user: nil } }

      expect {
        post products_path, params: product_hash
      }.wont_change "Product.count"

      must_redirect_to root_path
      expect(response.response_code).must_equal 302
    end
  end

  describe "show" do

    it "show a single product detail page" do
      id = Product.first.id

      get product_path(id)
      value(response).must_be :successful?
    end

    it "should repond with not_found if given an invalid id" do
      id = -1

      get product_path(id)

      must_respond_with :not_found
    end

  end

  describe "edit" do

    it "gets edit form page for a logged in merchant" do
      user = users(:laura)
      perform_login(user)

      id = products(:cake1).id

      get edit_product_path(id)
      value(response).must_be :successful?
    end

    it "should respond with not_found if an invalid product id is entered" do
      user = users(:laura)
      perform_login(user)

      id = products(:cake2).id

      get edit_product_path(id)

      must_redirect_to product_path(id)
      expect(flash[:danger]).must_equal "You don't have access to edit this product."
    end

    it "does not give a logged out user access to a product edit page" do
      id = products(:cake2).id

      get edit_product_path(id)

      must_redirect_to root_path
    end

    it "should respond with not_found if given an invalid id" do
      user = users(:laura)
      perform_login(user)

      id = -1

      get edit_product_path(id)

      must_respond_with :not_found
    end
  end

  describe "update" do
    let(:laura) {users(:laura)}
    let (:product_hash) do
      {
        product: {
          prod_name: product.prod_name,
          description: product.description,
          price: product.price,
          inv_qty: product.inv_qty,
          user: laura.id
        }
      }
    end

    it "a merchant can update their product" do
      user = users(:laura)
      perform_login(user)

      id = products(:cake1).id

      expect {
        patch product_path(id), params: product_hash
      }.wont_change "Product.count"

      must_redirect_to product_path
      expect(flash[:notice]).must_equal "#{product.prod_name} was successfully updated."

      new_product = Product.find_by(id: id)

      expect(new_product.prod_name).must_equal product_hash[:product][:prod_name]
      expect(new_product.description).must_equal product_hash[:product][:description]
    end

    it "a user not logged in cant update a product" do
      id = products(:cake1).id

      expect {
        patch product_path(id), params: product_hash
      }.wont_change "Product.count"

      must_redirect_to root_path(id)
    end

    it "a gives an error if the product params are invalid" do
      user = users(:laura)
      perform_login(user)

      cake1 = products(:cake1)
      product_hash[:product][:prod_name] = cake1.prod_name

      id = products(:cake2).id
      old_product = products(:cake2)

      expect {
        patch product_path(id), params: product_hash
      }.wont_change "Product.count"

      new_product = Product.find(id)

      must_respond_with :success
      expect(old_product.prod_name).must_equal new_product.prod_name
      expect(old_product.description).must_equal new_product.description
      expect(flash[:warning]).must_equal "Edit was unsuccessful"
    end

    it "gives not_found for a product that doesnt exist" do
      id = -1

      expect {
        patch product_path(id)
      }.wont_change 'Product.count'

      must_respond_with :not_found
    end
  end

  describe "category" do

      it "finds a category for product" do
        id = Category.first.id

        get category_path(id)

        value(response).must_be :successful?
      end

      it "redirects to root_path for invalid category" do
        id = 56

        get category_path(id)

        # value(response).must_be :successful?
        must_redirect_to root_path
        expect(flash[:warning]).must_equal "Category is invalid"
      end
    end


    describe "merchant" do

      it "finds a merchant for a product" do
        id = User.first.id

        get merchant_path(id)

        value(response).must_be :successful?
      end

      it "redirects to root_path for invalid category" do
        id = -56

        get merchant_path(id)

        # value(response).must_be :successful?
        must_redirect_to root_path
        expect(flash[:warning]).must_equal "User is invalid"
      end

    end

    describe "status" do

      it "changes an inactive product to active" do
        user = users(:laura)
        perform_login(user)

        product = Product.find_by(prod_name: "a wedding cake")

        patch product_status_path(product)

        # must_respond_with :redirect
        expect(product.active).must_equal true
      end

      it "changes an active product to inactive" do
        user = users(:laura)
        perform_login(user)

        product = Product.find_by(prod_name: "a wedding cake")
        product.active = true
        product.save

        patch product_status_path(product)
        product_new = Product.find_by(prod_name: "a wedding cake")

        # must_respond_with :redirect
        expect(product_new.active).must_equal false
        expect(flash[:notice]).must_equal "#{product.prod_name} status successfully retired."
      end

      it "reponds with not found for invalid product" do
        id = -56

        patch product_status_path(id)

        # value(response).must_be :successful?
        must_respond_with :not_found
      end

    end

end
