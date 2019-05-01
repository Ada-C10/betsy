require "test_helper"

describe CartsController do

  let (:product1) { products(:cake1) }

  let (:order_item_hash1) {
    {
      order_item: {
        product_id: product1.id,
        qty: 5
      }
    }
  }


  it "should get a cart's show if order exists" do
    post order_items_path, params: order_item_hash1
    order_id = Order.last.id

    get cart_path(order_id)

    must_respond_with :success

  end

  it "should respond with not_found given an invalid order_id" do
    order_id = -1

    get cart_path(order_id)

    must_respond_with :not_found

  end

end
