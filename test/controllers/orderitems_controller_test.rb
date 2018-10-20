require "test_helper"
require 'pry'
describe OrderitemsController do
  let(:product) { products(:fannypack) }
  let(:orderitem_hash) do
    {
      orderitem: {
        quantity: 9,
        product_id: product.id
      }
    }
  end
  let(:order){ orders(:ordlegend) }

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
    end

    it "will add orderitem to existing order when order exists" do
      order
      orderitem_hash[:orderitem][:order_id] = order.id

      expect {
        post orderitems_path, params: orderitem_hash
      }.wont_change "Order.count" # this test is failing because session[:order_id] is nil

      expect(session[:order_id]).wont_be_nil
    end

    it "will create a session for current order" do
      post orderitems_path, params: orderitem_hash

      expect(session[:order_id]).wont_be_nil
    end

  end
end
