require "test_helper"
require 'pry'
describe OrderitemsController do
  let(:product){ products(:kilimanjaro) }
  let(:order){ orders(:ordlegend) }
  let(:orderitem){ orderitems(:itemstwo)}
  let(:orderitem_hash) do
    {
      orderitem: {
        quantity: 9,
        product_id: product.id,
      }
    }
  end

  describe "create" do
    it "should create a new orderitem and order if one doesn't already exist" do
      start_count = Order.count

      expect {
        post orderitems_path, params: orderitem_hash
      }.must_change 'Orderitem.count', 1

      end_count = Order.count

      expect(end_count).must_equal (start_count + 1)

      must_respond_with :redirect
      must_redirect_to order_path(Orderitem.last.order_id)
    end

    it "should not save a new orderitem if given invalid data" do
      orderitem_hash[:orderitem][:quantity] = 0

      expect {
        post orderitems_path, params: orderitem_hash
      }.wont_change "Orderitem.count"

      expect(flash[:result_text]).must_equal "Could not save"
      must_respond_with :redirect
    end

    it "will create a session for current order" do
      post orderitems_path, params: orderitem_hash

      expect(session[:order_id]).wont_be_nil
    end

    it "will not add duplicate orderitem to cart" do
       post orderitems_path, params: orderitem_hash

       expect {
         post orderitems_path, params: orderitem_hash
       }.wont_change 'Orderitem.count'

       must_respond_with :redirect
    end
  end

  describe "update" do
    it "succeeds for valid data and an extant orderitem ID" do
      id = orderitems(:itemsone).id
      orderitem_hash[:orderitem][:order_id] = order.id

      expect {
        patch orderitem_path(id), params: orderitem_hash
      }.wont_change 'Orderitem.count'

      orderitem = Orderitem.find_by(quantity: 9)

      must_respond_with :redirect

      expect(orderitem.quantity).must_equal orderitem_hash[:orderitem][:quantity]
      expect(orderitem.product_id).must_equal orderitem_hash[:orderitem][:product_id]
      expect(orderitem.order_id).must_equal orderitem_hash[:orderitem][:order_id]
    end

    it "responds with bad request for invalid data" do
      orderitem_hash[:orderitem][:quantity] = 0

      id = orderitems(:itemsone).id
      old_orderitem = orderitems(:itemsone)

      expect {
        patch orderitem_path(id), params: orderitem_hash
      }.wont_change 'Orderitem.count'

      new_orderitem = Orderitem.find(id)

      must_respond_with :redirect
      expect(old_orderitem.quantity).must_equal new_orderitem.quantity
      expect(old_orderitem.product_id).must_equal new_orderitem.product_id
      expect(old_orderitem.order_id).must_equal new_orderitem.order_id
    end

    it "responds with not found for invalid orderitem ID" do
      id = -1

      expect {
        patch orderitem_path(id), params: orderitem_hash
      }.wont_change 'Orderitem.count'

      must_respond_with :not_found
    end
  end

  describe "destroy" do
    it "succeeds for an extant orderitem ID" do
      expect {
        delete orderitem_path(orderitem.id)
      }.must_change 'Orderitem.count', -1

      must_respond_with :redirect
      expect(Orderitem.find_by(id: orderitem.id)).must_be_nil
    end

    it "responds with not found and does not update the DB for invalid orderitem ID" do
      id = -1

      expect {
        delete orderitem_path(id)
      }.wont_change 'Orderitem.count'

      must_respond_with :not_found
    end
  end
end
