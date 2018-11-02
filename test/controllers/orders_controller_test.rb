require "test_helper"

describe OrdersController do
  let(:pending_order) { orders(:pending_order) }
  let(:empty_order) { orders(:empty_order) }
  let(:dress) { products(:dress) }
  let(:dress_hash) {
    dress_hash = {
      order_product: {
        product_id: products(:dress).id,
        quantity: 1,
      }
    }
  }

  describe "cart" do
    it "succeeds when things are in the cart" do
      # Arrange
      get product_path(dress.id)
      post order_products_path, params: dress_hash

      # Act
      get cart_path

      # Assert
      must_respond_with :success
      expect(Order.find_by(id: session[:order_id]).order_products.any?).must_equal true
    end

    it "succeeds when nothing is in the cart" do
      # Arrange
      get root_path

      # Act
      get cart_path

      # Assert
      must_respond_with :success
      expect(session[:order_id]).must_be_nil
    end
  end

  describe "checkout" do
    it "succeeds when things are in the cart" do
      # Arrange
      get product_path(dress.id)
      post order_products_path, params: dress_hash

      # Act
      get checkout_path

      # Assert
      must_respond_with :success
      expect(Order.find_by(id: session[:order_id]).order_products.any?).must_equal true
    end

    it "redirects back to the cart when the cart is empty" do
      # Arrange
      get root_path

      # Act
      get checkout_path

      # Assert
      must_respond_with :redirect
      must_redirect_to cart_path
      expect(flash[:warning]).must_equal "You must add something to your cart before you can checkout"
    end
  end

  describe "update" do
    it "succeeds for valid data and an existing order ID" do
      # Arrange done with let
      get product_path(dress.id)
      post order_products_path, params: dress_hash

      order = Order.find_by(id: session[:order_id])

      order_user_hash = {
        order: {
          user_attributes: {
            id: order.user.id,
            name: "Henrietta",
            email: 'email@email.com',
            provider: 'github',
            cc_num: 8790451276789084,
            cc_csv: 678,
            cc_exp: '09/08/22',
            address: '123 Main St USA',
            bill_zip: 10012
          }
        }
      }

      expect {
        patch order_path(order.id), params: order_user_hash
      }.wont_change 'Order.count'

      must_respond_with :redirect
      must_redirect_to confirmation_path

      expect(Order.find_by(id: order.id).status).must_equal "paid"
      expect(session[:order_id]).must_be_nil
    end

    it "redirects when given bogus data" do
      get product_path(dress.id)
      post order_products_path, params: dress_hash

      order = Order.find_by(id: session[:order_id])

      order_user_hash = {
        order: {
          user_attributes: {
            id: order.user.id,
            name: "Henrietta",
            email: 'email@email.com',
            cc_num: 'should be invalid',
            cc_csv: 123,
            cc_exp: '09/08/22',
            address: '123 Main St USA',
            bill_zip: 10012
          }
        }
      }

      expect {
        patch order_path(order.id), params: order_user_hash
      }.wont_change 'Order.count'

      must_respond_with :redirect
      must_redirect_to checkout_path
      expect(order.status).must_equal "pending"
      expect(flash[:warning]).must_equal "Could not submit order"
      expect(session[:order_id]).must_equal order.id
    end
  end

  describe "confirmation" do
    it "succeeds when given valid data" do
      # Arrange
      get product_path(dress.id)
      post order_products_path, params: dress_hash

      order = Order.find_by(id: session[:order_id])

      order_user_hash = {
        order: {
          user_attributes: {
            id: order.user.id,
            name: "Henrietta",
            email: 'email@email.com',
            provider: 'github',
            cc_num: 8790451276789084,
            cc_csv: 678,
            cc_exp: '09/08/22',
            address: '123 Main St USA',
            bill_zip: 10012
          }
        }
      }

      # Act - Assert
      patch order_path(order.id), params: order_user_hash
      expect(session[:paid_order_id]).must_equal order.id

      get confirmation_path

      must_respond_with :success
      expect(session[:paid_order_id]).must_be_nil
    end

    it "fails if order has not been paid for" do
      get product_path(dress.id)
      post order_products_path, params: dress_hash

      order = Order.find_by(id: session[:order_id])

      get checkout_path
      get confirmation_path

      must_respond_with :redirect
      must_redirect_to checkout_path
      expect(flash[:warning]).must_equal "Error: Order payment did not go through"
    end
  end
end
