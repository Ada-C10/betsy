require "test_helper"

describe OrderProductsController do
  let (:dress) { products(:dress) }
  let (:dresses) { order_products(:dresses) }
  let (:mumu) { products(:mumu) }
  let (:pending_order) { orders(:pending_order) }
  let (:op_hash) { { order_product: {
    product_id: mumu.id,
    status: "pending",
    quantity: 2
  }

  } }

  describe "create" do
    it "creates a new order product with valid data" do
      # Arrange
      get product_path(mumu.id)

      # Act
      expect {
        post order_products_path, params: op_hash
      }.must_change 'OrderProduct.count', 1

      expect(Order.find_by(id: session[:order_id]).order_products.count).must_equal 1

      must_respond_with :redirect
      must_redirect_to cart_path

      expect(OrderProduct.last.product.id).must_equal op_hash[:order_product][:product_id]
      expect(OrderProduct.last.order_id).must_equal session[:order_id]
      expect(OrderProduct.last.status).must_equal op_hash[:order_product][:status]
      expect(OrderProduct.last.quantity).must_equal op_hash[:order_product][:quantity]

      expect(session[:order_id]).must_equal (OrderProduct.last.order.id)
    end

    it "redirects back to the product page and does not update the DB for bogus data" do
      # Arrange
      op_hash = {
        order_product: {
          product_id: mumu.id,
          status: "pending",
          quantity: 20
        }
      }

      # Act
      expect {
        post order_products_path, params: op_hash
      }.wont_change 'OrderProduct.count'

      expect(Order.find_by(id: session[:order_id])).must_be_nil

      must_respond_with :redirect
      must_redirect_to products_path

      expect(flash[:warning]).must_equal "Error: Could not add product to cart"
    end
  end

  describe "update" do
    it "succeeds for valid data and an existing order_product" do
      # Arrange
      post order_products_path, params: op_hash
      op = OrderProduct.last
      order = Order.find_by(id: op.order.id)
      start_count = order.order_products.count

      op_hash2 = {
        order_product: {
          quantity: 1
        }
      }

      expect {
        patch order_product_path(op.id), params: op_hash2
      }.wont_change 'OrderProduct.count'

      # TODO: not saving to pending_order, likely because creating new order in @current_order
      expect(order.order_products.count).must_equal start_count

      must_respond_with :redirect
      must_redirect_to cart_path

      expect(OrderProduct.last.product_id).must_equal op_hash[:order_product][:product_id]
      expect(OrderProduct.last.order.id).must_equal session[:order_id]
      expect(OrderProduct.last.status).must_equal op_hash[:order_product][:status]
      expect(OrderProduct.last.quantity).must_equal op_hash2[:order_product][:quantity]
    end

    it "redirects back to the product page and does not update the DB for bogus data" do
      # Arrange
      post order_products_path, params: op_hash
      op = OrderProduct.last
      order = Order.find_by(id: op.order.id)
      start_count = order.order_products.count

      op_hash2 = {
        order_product: {
          quantity: 100
        }
      }

      expect {
        patch order_product_path(op.id), params: op_hash2
      }.wont_change 'OrderProduct.count'

      # TODO: not saving to pending_order, likely because creating new order in @current_order
      expect(order.order_products.count).must_equal start_count

      must_respond_with :redirect
      must_redirect_to cart_path

      expect(flash[:warning]).must_equal "Error: Could not update product order"
    end

    it "reduces the order product count by 1 if quantity is adjusted to 0" do
      # Arrange
      post order_products_path, params: op_hash
      op = OrderProduct.last
      order = Order.find_by(id: op.order.id)
      start_count = order.order_products.count

      op_hash2 = {
        order_product: {
          quantity: 0
        }
      }

      expect {
        patch order_product_path(op.id), params: op_hash2
      }.must_change 'OrderProduct.count', -1

      expect(order.order_products.count).must_equal (start_count - 1)

      must_respond_with :redirect
      must_redirect_to cart_path

      expect(flash[:success]).must_equal "Removed #{op.product.name} from cart"
    end
  end

  describe "destroy" do
    it "succeeds for an existing order product ID" do
      # Arrange done with let

      # Act
      expect {
        delete order_product_path(dresses.id)
      }.must_change 'OrderProduct.count', -1

      must_respond_with :redirect
      must_redirect_to cart_path

      expect(flash[:success]).must_equal "Removed #{dresses.product.name} from cart"

      expect(OrderProduct.find_by(id: dresses.id)).must_be_nil
    end

    it "displays a flash message and does not update the DB for a bogus order product" do
      id = -1

      expect {
        delete order_product_path(id)
      }.wont_change 'OrderProduct.count'

      must_respond_with :redirect
      must_redirect_to cart_path

      expect(flash[:warning]).must_equal "Error: Could not remove product from cart"
    end
  end

  describe "change_status" do
    it "updates the order product status if current user is the product seller" do
      # Arrange
      dresses.status = "paid"
      dresses.save

      perform_login(merchants(:merchant))

      patch change_status_path(dresses.id, "shipped")

      must_respond_with :redirect
      must_redirect_to merchant_dash_path(merchants(:merchant).id)

      expect(flash[:success]).must_equal "Updated status for Product Order ##{dresses.id} to shipped"
    end

    it "updates the order product status if current user is the buyer" do
      # Arrange
      dresses.status = "paid"
      dresses.save

      perform_login(users(:user1))

      patch change_status_path(dresses.id, "cancelled")

      must_respond_with :redirect
      must_redirect_to root_path

      expect(flash[:success]).must_equal "Cancelled Product Order ##{dresses.id}"
    end

    it "does not update the status if the current user doesn't have appropriate permissions" do
      # Arrange
      dresses.status = "paid"
      dresses.save

      perform_login(users(:no_order_user))

      patch change_status_path(dresses.id, "cancelled")

      must_respond_with :redirect
      must_redirect_to root_path

      expect(flash[:warning]).must_equal "Could not update status for Product Order ##{dresses.id}"
    end
  end
end
