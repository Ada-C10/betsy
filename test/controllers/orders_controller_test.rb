require "test_helper"

describe OrdersController do

  let (:delete_all) {
    Order.all.each do |order|
      order.destroy
    end
  }

  let (:order_data) {
    {
      order: {
        status: 'paid',
        name: 'Ada',
        email: 'ada@adacademy.com',
        address: '123 Street Dr. Seattle, WA',
        cc_num: 1123384229389283,
        cc_cvv: 280,
        cc_expiration: '2020-09-01'
      }
    }
  }

  let (:existing_order) {
    orders(:bob)
  }

  describe "index" do
    it "succeeds with orders present" do
      get orders_path

      must_respond_with :success
    end

    it "succeeds with no orders present" do
      delete_all

      get orders_path

      must_respond_with :success
    end
  end

  describe "create" do
    it "can create an order" do
      test_order = Order.new(order_data[:order])
      expect(test_order).must_be :valid?, "Order data was invalid. Please fix."

      expect{
        post orders_path, params: order_data
      }.must_change('Order.count', +1 )

      must_redirect_to order_path(Order.last)
      must_respond_with :redirect
    end
  end

  describe "edit" do
    it "succeeds with an extant order ID" do
      get edit_order_path(existing_order.id)

      must_respond_with :success
    end

    it "renders 404 not_found for a bogus order ID" do
      existing_order.destroy

    expect{
      get edit_order_path(existing_order.id)
    }.must_raise(ActionController::RoutingError)

    end
  end

  describe "update" do
    it "succeeds for valid data and an extant work ID" do
      test_order = Order.new(order_data[:order])
      expect(test_order).must_be :valid?, "Order data was invalid. Please fix."

      expect {
        patch order_path(existing_order.id), params: order_data
      }.wont_change('Order.count')

      existing_order.reload
      (existing_order.email).must_equal test_order.email
      (existing_order.name).must_equal test_order.name
      (existing_order.address).must_equal test_order.address

      must_redirect_to order_path(existing_order.id)
    end

    it "renders 404 not_found for a bogus order ID" do
      existing_order.destroy

    expect{
      patch order_path(existing_order.id), params: order_data
    }.must_raise(ActionController::RoutingError)

    end
  end

  describe "destroy" do
    it "succeeds for an extant order ID with status not cancelled" do
      expect {
        delete order_path(existing_order.id)
      }.must_change('Order.count', -1)

      must_respond_with :redirect
      must_redirect_to root_path
    end

    it "renders 404 not_found and does not update the DB for a bogus order ID" do
      existing_order.destroy

      expect{
        delete order_path(existing_order.id)
      }.must_raise(ActionController::RoutingError)

    end
  end


end
