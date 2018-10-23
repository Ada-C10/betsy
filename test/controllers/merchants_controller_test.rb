require "test_helper"

describe MerchantsController do
  let(:fred) {merchants(:fred)}
  let(:merchant) {merchants(:sally)}
  let(:order) {orders(:ordciara)}

  it "should get index " do
    get merchants_path
    must_respond_with :success
  end

  describe "show" do
    it "should get a merchant's show page" do
      id = merchants(:kiki).id
      get merchant_path(id)
      must_respond_with :success
    end

    it "should respond with not found if given a bad id" do
      id = -1
      get merchant_path(id)
      must_respond_with :not_found
    end
  end

  describe "dashboard" do
    it "should get a merchant's dashboard" do
      perform_login(fred)
      get dashboard_path
      must_respond_with :success
    end

  # authorization test
    it "a user that's not logged in cannot access dashboard" do
      get dashboard_path
      must_respond_with :redirect
      must_redirect_to root_path
    end
  end

  describe "customer" do
    before do
      perform_login(fred)
    end
    let(:params){{merchant_id: merchant.id, order_id: order.id}}

    it "should get the customer view" do
      get merchant_customer_path(params)
      must_respond_with :success
    end

    it "will redirect to not found if there's no merchant" do
      params[:merchant_id] = -1
      get merchant_customer_path(params)
      must_respond_with :not_found
    end

    it "will redirect to not found if there's no order" do
      params[:order_id] = -1
      get merchant_customer_path(params)
      must_respond_with :not_found
    end
  end

  describe "ship" do
    before do
      perform_login(fred)
    end

    it "can change status from paid to complete" do
      my_order = order.dup
      expect(my_order.status).must_equal "paid"
      params = {merchant_id: merchant.id, order_id: order.id}
      expect{patch merchant_ship_path(params)}.wont_change 'Order.count'
      expect(my_order.status).must_equal "complete"
      must_respond_with :success
    end

    it "can change status from complete to paid" do
      my_order = orders(:ordrussell).dup
      expect(my_order.status).must_equal "complete"
      params = {merchant_id: merchant.id, order_id: order.id}
      expect{patch merchant_ship_path(params)}.wont_change 'Order.count'
      expect(my_order.status).must_equal "paid"
      must_respond_with :success
    end

    it "will redirect to not found if there's no order" do
      params = {merchant_id: merchant.id, order_id: order.id}
      expect{patch merchant_ship_path(params)}.wont_change 'Order.count'
      must_respond_with :not_found
    end

    it "should redirect to the root path if user is not logged in" do
      get dashboard_path

      must_respond_with :redirect
      must_redirect_to root_path
    end

  end

end
