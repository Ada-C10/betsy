require "test_helper"

describe OrderitemsController do
  let(:product) { products(:kilimanjaro) }
  let(:orderitem_hash) do
    {
      orderitem: {
        quantity: 9,
        product_id: product.id
      }
    }
  end

  describe "create" do
    it "should create a new orderitem" do
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
      }.wont_change 'Orderitem.count'

      must_respond_with :internal_server_error
    end

    it "will add orderitem to existing order when order exists" do
    end

    it "will create a session for current order" do
      post orderitems_path, params: orderitem_hash

      expect(session[:order_id]).wont_be_nil
    end

  end
end
