require "test_helper"
describe SessionsController do
  describe 'create' do
    let(:kit) { users(:kit) }

    it "logs in an exiting user and redirects to the root route" do
      expect {perform_login(kit)}.wont_change('User.count')

      must_redirect_to root_path
      expect(session[:user_id]).must_equal kit.id
    end

    it "creates an account for a new user and redirects to the root route" do
      stub_auth_hash!(
        uid: '12343',
        provider: 'github',
        info: {
          email: 'test@example.com',
          name: 'test'
        }
      )

      expect { get login_path('github') }.must_change('User.count', 1)

      must_redirect_to root_path
      expect(session[:user_id]).wont_be_nil
    end

    it "doesn't create an account for a new user with invalid data" do
      stub_auth_hash!(
        uid: '12343',
        provider: 'github',
        info: {
          email: kit.email,
          name: kit.name
        }
      )

      expect { get login_path('github') }.wont_change('User.count', 1)

      expect(flash.keys).must_equal ["danger"]
      expect(session[:user_id]).must_be_nil
      must_respond_with :redirect
    end
  end

  describe "destroy" do
    before do
      @kit = users(:kit)
      perform_login(@kit)
    end

    it "makes session[:user_id] nil " do
      delete logout_path

      expect(session[:user_id]).must_be_nil
      assert_equal 'Successfully logged out', flash[:success]
      must_respond_with :redirect
    end

    it "the user is logged out " do
      expect(session[:user_id]).must_equal @kit.id

      delete logout_path

      expect(session[:user_id]).must_be_nil
      assert_equal 'Successfully logged out', flash[:success]
      must_respond_with :redirect
    end

    it "the user can no longer access  certain pages" do
      delete logout_path

      get get_orders_path
      must_redirect_to root_path
      expect(flash[:danger]).must_equal "Sorry, the fulfillment page is only for creature rescuers."
    end
  end

  describe 'add_to_cart' do
    before do
      @lamb = products(:lamb)
      @quantity_hash = { quantity: "3" }
    end

    it "adds a new product to a cart" do
      #add to cart
      post add_to_cart_path(@lamb.id), params: @quantity_hash

      #check quantity against quantity_hash
      expect(session[:cart]).must_include @lamb.id => @quantity_hash[:quantity].to_i
      expect(session[:cart].length).must_equal 1

      must_respond_with :redirect
    end

    it "updates the quantity of the cart" do
      #add to cart
      post add_to_cart_path(@lamb.id), params: @quantity_hash

      #check quantity against quantity_hash
      expect(session[:cart].first.values[0]).must_equal @quantity_hash[:quantity].to_i

      #add to cart again
      post add_to_cart_path(@lamb.id), params: @quantity_hash

      #check quantity against quantity_hash times two
      expect(session[:cart].first.values[0]).must_equal @quantity_hash[:quantity].to_i * 2
      must_respond_with :redirect
    end

    it "won't add to cart if there isn't enough stock or invalid stock" do
      large_quantity_hash = { quantity: "20" }
      post add_to_cart_path(@lamb.id), params: large_quantity_hash
      expect(session[:cart]).must_equal []

      invalid_quantity_hash = {quantity: "hello"}
      post add_to_cart_path(@lamb.id), params: invalid_quantity_hash
      expect(session[:cart]).must_equal []
    end

    it "won't add item to cart if there isn't enough stock due to that item already being in cart" do
      quantity_hash = { quantity: "5" }
      post add_to_cart_path(@lamb.id), params: quantity_hash

      large_quantity_hash = { quantity: "6" }
      post add_to_cart_path(@lamb.id), params: large_quantity_hash
      expect(flash[:warning]).wont_be_nil
      expect(session[:cart]).must_equal [{@lamb.id.to_s => 5}]
    end

    it "won't add to cart if the product can't be found" do
      quantity_hash = { quantity: "5" }
      id = "hello"

      post add_to_cart_path(id), params: quantity_hash

      expect(session[:cart]).must_equal []
      assert_response :not_found
    end
  end

  describe 'remove_from_cart' do
    before do
      @lamb = products(:lamb)
      @goat = products(:goat)
      @quantity_hash = { quantity: "3" }
      post add_to_cart_path(@lamb.id), params: @quantity_hash
    end

    it "removes item from cart" do
      expect(session[:cart].length).must_equal 1

      get remove_from_cart_path(@lamb.id)
      expect(session[:cart].length).must_equal 0
    end

    it "removes specific item from cart" do
      post add_to_cart_path(@goat.id), params: @quantity_hash

      expect(session[:cart].length).must_equal 2

      get remove_from_cart_path(@lamb.id)
      expect(session[:cart].length).must_equal 1
      expect(session[:cart]).wont_include @lamb.id => @quantity_hash[:quantity].to_i
      expect(session[:cart]).must_include @goat.id.to_s => @quantity_hash[:quantity].to_i
    end
  end


  describe 'update_quantity' do
    before do
      @lamb = products(:lamb)
      @quantity_hash = { quantity: "3" }
      @original_quantity = @quantity_hash[:quantity].to_i
      post add_to_cart_path(@lamb.id), params: @quantity_hash
    end

    it "updates the quantity if there is enough stock" do
      new_quantity_hash = { quantity: "5" }

      patch update_cart_path(@lamb.id), params: new_quantity_hash
      expect(session[:cart].first.values[0].must_equal new_quantity_hash[:quantity].to_i)
    end

    it "doesn't update the quantity if there isn't enough stock" do
      new_quantity_hash = { quantity: "50" }

      expect {
        patch update_cart_path(@lamb.id), params: new_quantity_hash
      }.wont_change 'session[:cart].first.values[0]'

      expect(session[:cart].first.values[0]).must_equal @original_quantity
    end
  end

  describe 'cart_view' do
    before do
      @lamb = products(:lamb)
      @quantity_hash = { quantity: "3" }
    end

    it "succeeds when there are items in cart" do
      post add_to_cart_path(@lamb.id), params: @quantity_hash

      get cart_path

      must_respond_with :success
    end

    it "succeeds when there aren't items in cart" do
      get cart_path

      must_respond_with :success
    end
  end

end
