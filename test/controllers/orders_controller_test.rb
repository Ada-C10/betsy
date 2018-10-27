require "test_helper"

describe OrdersController do
  let(:product){ products(:kilimanjaro) }
  let(:order) { orders(:ordciara) }
  let(:fred) { merchants(:fred) }
  let(:orderitem_hash) do
    {
      orderitem: {
        quantity: 9,
        product_id: product.id,
        order_id: order.id
      }
    }
  end

  let(:order_hash) do
    {
      order: {
        name: order.name,
        email: order.email,
        address: order.address,
        cc_num: order.cc_num,
        cvv: order.cvv,
        exp_date: order.exp_date,
        zip: order.zip
      }
    }
  end

  describe "show" do
    it "succeeds for an extant order ID" do
      post orderitems_path, params: orderitem_hash
      expect(session[:order_id]).wont_be_nil

      get order_path(order.id)

      must_respond_with :success
    end

    it "succeeds for an order ID of cart" do
      get order_path("cart")

      must_respond_with :success
    end

    it "renders 404 not_found for an invalid order ID" do
      id = -1

      get order_path(id)

      must_respond_with :not_found
    end

    it "succeeds for an existing order whose status is paid" do
      get order_path(order.id)

      must_respond_with :success
    end

    it "succeeds for a pending order" do
      order = orders(:ordfred)
      id = "cart"

      orderitem_hash =
        {
          orderitem: {
            quantity: 9,
            product_id: products(:safari).id,
            order_id: order.id
          }
        }

      post orderitems_path, params: orderitem_hash
      expect(session[:order_id]).wont_be_nil

      get order_path(id)

      must_respond_with :success
    end
  end

  describe "edit" do
    it "succeeds for an existing order ID and guest user" do
      post orderitems_path, params: orderitem_hash
      expect(session[:order_id]).wont_be_nil

      get edit_order_path(order.id)

      must_respond_with :success
    end

    it "renders not_found for an invalid order ID" do
      order.id = -1

      get edit_order_path(order.id)

      must_respond_with :not_found
    end

    it "succeeds for an existing order ID and logged in user" do
      order = orders(:ordfred)
      orderitem_hash =
      {
        orderitem: {
          quantity: 9,
          product_id: product.id,
          order_id: order.id
        }
      }
      post orderitems_path, params: orderitem_hash
      expect(session[:order_id]).wont_be_nil

      perform_login(fred)
      expect(session[:user_id]).wont_be_nil

      get edit_order_path(order.id)

      must_respond_with :success
    end
  end

  describe "update" do
    it "succeeds for valid data and an extant product ID" do
      post orderitems_path, params: orderitem_hash
      expect(session[:order_id]).wont_be_nil

      patch order_path(order.id), params: order_hash

      must_respond_with :redirect
      must_respond_with :found
    end

    it "renders bad_request for invalid data" do
      post orderitems_path, params: orderitem_hash
      expect(session[:order_id]).wont_be_nil

      order_hash[:order][:cvv] = nil
      patch order_path(order.id), params: order_hash

      must_respond_with :bad_request
    end

    it "responds with not found for an invalid order ID" do

      orderitem_hash[:orderitem][:order_id] = nil

      patch order_path(order.id), params: order_hash

      must_respond_with :not_found
    end

  end
end
