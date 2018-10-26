require "test_helper"

describe OrdersController do

  describe " update" do
    let (:order_hash) do
      {
        order: {
          status: "pending", street: "884 Ada Academy", city: "seattle", state: "WA", zip: 98112,
          creditcard: 1234, cvv: 234, billingzip: 98112, ccexpiration: Date.today
        }
      }
    end


    describe "update" do
      it "will create a new order with the passed params if the order isn't @current_order and change order status from pending to paid" do
      order = orders(:one)
      expect {
      patch order_path(order.id), params: order_hash
    }.must_change 'Order.count', 1

      order = Order.all.last
      must_respond_with :redirect
      must_redirect_to confirmation_path(order.id)

      expect(order.status).must_equal "paid"
      expect(order.street).must_equal order_hash[:order][:street]
      expect(order.city).must_equal order_hash[:order][:city]
      expect(order.state).must_equal order_hash[:order][:state]
      expect(order.zip).must_equal order_hash[:order][:zip]
      expect(order.creditcard).must_equal order_hash[:order][:creditcard]
      expect(order.cvv).must_equal order_hash[:order][:cvv]
      expect(order.billingzip).must_equal order_hash[:order][:billingzip]
    end


        it "should get an order's show page" do
          #Arrange
          id = orders(:one).id
          #Act
          get order_path(id)
          #Assert
          must_respond_with :success
        end

        it "should respond with not_found if given an invalid id" do
          #asrrange - invalid id
          id = -1
          #Act
          get order_path(id)
          #Assert
          must_respond_with :not_found
          expect(flash[:danger]).must_equal "Cannot find the order -1"
        end
    #
    # #
    describe "edit" do
     it "can get the edit page for a valid order" do
       # Arrange
       id = orders(:one).id

       # Act
       get edit_order_path(id)

       # Assert
       must_respond_with :success
     end

     it "should respond with not_found if given an invalid id" do
       # Arrange - invalid id
       id = -1
       # Act
       get edit_order_path(id)

       # Assert
       expect(response).must_be :not_found?
       must_respond_with :not_found
       expect(flash[:danger]).must_equal "Cannot find the order -1"
       end
     end

      end
    end

    describe "show" do

      it "should get an order's show page" do
        #Arrange
        id = orders(:one).id
        #Act
        get order_path(id)
        #Assert
        must_respond_with :success
      end

      it "should respond with not_found if given an invalid id" do
        #asrrange - invalid id
        id = -1
        #Act
        get order_path(id)
        #Assert
        must_respond_with :not_found
        expect(flash[:danger]).must_equal "Cannot find the order -1"
      end

    end


 end
