require "test_helper"

describe OrderproductsController do
  describe "update" do
    it "updates the status to pending or shipped" do
      orderproduct1 = orderproducts(:orderproduct1)
      status_hash = {
        orderproduct: {
          status: "shipped"
        }
      }

      patch orderproduct_path(orderproduct1.id), params: status_hash

      must_respond_with  :redirect
      assert_equal "Status of requested creature has been changed.", flash[:success]
      updated_orderproduct1 = Orderproduct.find_by(id: orderproduct1.id)

      expect(updated_orderproduct1.status).must_equal status_hash[:orderproduct][:status]
      expect(orderproduct1.status).wont_equal updated_orderproduct1.status
    end

    it "doesnt update the status with invalid options" do
      orderproduct1 = orderproducts(:orderproduct1)
      status_hash = {
        orderproduct: {
          status: "cheese"
        }
      }

      patch orderproduct_path(orderproduct1.id), params: status_hash

      must_respond_with  :redirect
      assert_equal 'Status could not be changed.', flash[:warning]
      updated_orderproduct1 = Orderproduct.find_by(id: orderproduct1.id)

      expect(updated_orderproduct1.status).wont_equal status_hash[:orderproduct][:status]
      expect(orderproduct1.status).must_equal updated_orderproduct1.status
    end

    it "only updates the status" do
      orderproduct1 = orderproducts(:orderproduct1)
      status_hash = {
        orderproduct: {
          quantity: 1
        }
      }

      patch orderproduct_path(orderproduct1.id), params: status_hash

      must_respond_with  :redirect
      assert_equal 'Status could not be changed.', flash[:warning]
      updated_orderproduct1 = Orderproduct.find_by(id: orderproduct1.id)

      expect(updated_orderproduct1.status).wont_equal status_hash[:orderproduct][:quantity]
      expect(orderproduct1.quantity).must_equal updated_orderproduct1.quantity
    end
  end
end
