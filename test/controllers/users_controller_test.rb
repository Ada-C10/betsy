require "test_helper"

describe UsersController do
  # it "must be a real test" do
  #   flunk "Need real tests"
  # end

  before do
    @linda = users(:one)
    @john = users(:two)
    @june = users(:june)
  end

  describe "show" do
    it "succeeds for an exisiting user / merchant with items" do

      get user_path(@linda)
      must_respond_with :success
    end

    it "succeeds for an exisiting user / merchant without items" do

      get user_path(@june)
      must_respond_with :success
    end

    it "renders 404 not_found for a non exiting user" do

      get user_path(0)
      must_respond_with :not_found
    end
  end

  let (:logged_in_merchant) {
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(@linda))

    get auth_callback_path(:github)
  }

  let (:logged_in_user) {
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(@june))

    get auth_callback_path(:github)
  }

  describe "shop" do
    it "succeeds for a logged in user / merchant with items" do
      # skip

      logged_in_merchant

      expect(session[:user_id]).must_equal @linda.id

      get shop_path(@linda)
      must_respond_with :success
    end

    it "succeeds for an exisiting user / merchant without items" do

      logged_in_user

      expect(session[:user_id]).must_equal @june.id

      get shop_path(@june)
      must_respond_with :success
    end

    it "redirects with flash error message for a non exiting user" do

      get shop_path(0)
      must_redirect_to root_path
      assert_equal 'You need to sign up to create a shop.', flash[:error]
    end
  end

  describe 'User#merchant pending orders and User#paid' do

    let (:logged_in_user) {
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(@linda))

      get auth_callback_path(:github)
    }

    it 'succeeds if a merchant has a pending order' do
      logged_in_user

      get pending_path
      must_respond_with :success
    end

    it 'changes the status of an order to shipped'do
      @item = items(:shoes)
      @order = orders(:one)
      @new_order_item = OrderItem.create(order_id: @order.id, item_id: @item.id, quantity_per_item: 3)

      post paid_path(@new_order_item.id)
       find_shipped_order_item = OrderItem.find_by(status: "shipped")

       expect(find_shipped_order_item.id).must_equal @new_order_item.id
       must_respond_with :redirect
    end
  end
end
