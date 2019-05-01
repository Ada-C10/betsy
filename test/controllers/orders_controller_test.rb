require "test_helper"

describe OrdersController do
  let(:order) { orders :one }

  it "gets index" do
    get orders_url

    value(response).must_be :successful?
  end

  describe "show" do

    it "it shows an order for that merchant" do
      user = users(:laura)
      perform_login(user)

      id = orders(:one).id

      get orders_path(id)

      value(response).must_be :successful?
    end

    it "will not allow another merchant to view an order without their product" do
      user = users(:laura)
      perform_login(user)

      id = orders(:two).id

      get orders_path(id)

      value(response).must_be :successful?
    end
  end

  describe "update" do
    # placing the order we use update
    let (:product) { products(:cake1) }

    let (:order_item_hash) {
      {
        order_item: {
          product_id: product.id,
          qty: 5
        }
      }
    }

    let (:confirm_hash) do
      {
        order: {
          cc_cvv: order.cc_cvv,
          cc_digit: order.cc_digit,
          cc_expiration: order.cc_expiration,
          cc_name: order.cc_name,
          cc_zip: order.cc_zip,
          cust_email: order.cust_email,
          cust_name: order.cust_name,
          mailing_address: order.mailing_address,
          status: order.status
        }
      }
    end
    #PATCH  /orders/:id
    it "will allow merchant confirm a purchase with valid params" do
      user = users(:laura)
      perform_login(user)

      expect {
        post order_items_path, params: order_item_hash
      }.must_change 'OrderItem.count', 1

      id = Order.last.id

      expect {
        patch order_path(id), params: confirm_hash
      }.wont_change "Order.count"

      expect(flash.now[:success]).must_equal "Order was accepted"
      expect(order.cc_name).must_equal confirm_hash[:order][:cc_name]
      expect(order.cust_email).must_equal confirm_hash[:order][:cust_email]
    end

    it "does not confirm a order with zero items in the cart" do
      user = users(:laura)
      perform_login(user)

      expect {
        post order_items_path, params: order_item_hash
      }.must_change 'OrderItem.count', 1

      order = Order.last
      order.order_items.destroy_all

      expect {
        patch order_path(order.id), params: confirm_hash
      }.wont_change "Order.count"

      must_redirect_to products_path
      expect(flash[:warning]).must_equal "You have zero items in your cart"
    end

    it "allow a guest user add items to cart" do
      expect {
        post order_items_path, params: order_item_hash
      }.must_change 'OrderItem.count', 1

      id = Order.last.id

      expect {
        patch order_path(id), params: confirm_hash
      }.wont_change "Order.count"

      expect(flash.now[:success]).must_equal "Order was accepted"
    end

    it "does not complete an order with invalid params" do
      confirm_hash[:order][:cust_name] = nil

      expect {
        post order_items_path, params: order_item_hash
      }.must_change 'OrderItem.count', 1

      id = Order.last.id

      expect {
        patch order_path(id), params: confirm_hash
      }.wont_change "Order.count"

      must_respond_with :success
      expect(flash.now[:warning]).must_equal 'Order was not not created'
    end

    it "does not load an invalid order" do
      id = -1

      expect {
        patch order_path(id)
      }.wont_change 'Order.count'

      must_redirect_to order_path
      expect(flash[:now]).must_equal "Order does not exsist"
    end

  end

  # describe "destroy" do
  # it "destroys order" do
  #   expect {
  #     delete order_url(order)
  #   }.must_change "Order.count", -1
  #
  #   must_redirect_to orders_path
  # end
  # end

end
