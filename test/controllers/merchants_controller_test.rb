require "test_helper"

describe MerchantsController do
  let(:fred) {merchants(:fred)}
  let(:merchant) {merchants(:sally)}
  let(:order) {orders(:ordciara)}
  let(:order_complete) {orders(:ordrussell)}

  it "should get index " do
    get merchants_path
    must_respond_with :success
  end

  describe "show" do
    it "should get a merchant's show page" do
      id = merchants(:kiki).id
      get merchant_path(id)
      must_respond_with :success
    end

    it "should respond with not found if given a bad id" do
      id = -1
      get merchant_path(id)
      must_respond_with :not_found
    end
  end

  describe "guest users" do

    describe "dashboard" do
      it "a user that's not logged in cannot access dashboard" do
        get dashboard_path
        expect(session[:user_id]).must_be_nil
        must_respond_with :redirect
        must_redirect_to root_path
      end
    end

    describe "customer" do
      it "guest user should not be able to access merchant's orders" do
        get merchant_customer_path(merchant.id, order.id)
        must_redirect_to root_path
      end
    end

    describe "merchant ship" do
      it "should redirect to the root path if user is not logged in" do
        patch merchant_ship_path(merchant.id, order.id)
        must_respond_with :redirect
        must_redirect_to root_path

      end
    end
  end

  describe "logged in users" do

    before do
      perform_login(fred)
    end

    describe "dashboard" do
      it "should get a merchant's dashboard" do
        expect(session[:user_id]).wont_be_nil
        get dashboard_path
        must_respond_with :success
      end
    end

    describe "customer" do
      let(:params){{merchant_id: merchant.id, order_id: order.id}}

      it "should get the customer view" do
        get merchant_customer_path(params)
        must_respond_with :success
      end

      it "will redirect to not found if there's no merchant" do
        params[:merchant_id] = -1
        get merchant_customer_path(params)
        must_respond_with :not_found
      end

      it "will redirect to not found if there's no order" do
        params[:order_id] = -1
        get merchant_customer_path(params)
        must_respond_with :not_found
      end
    end
    describe "ship" do

      let (:params_hash) {
        {
          order: {
            merchant_id: merchant.id,
            order_id: order.id,
            status: "complete"
          }
        }
      }

      it "can change status from paid to complete" do

        old_order = Order.find_by(id: order.id)
        expect(old_order.status).must_equal "paid"
        expect {
          patch merchant_ship_path, params: params_hash
        }.wont_change 'Order.count'
        must_respond_with :redirect
        must_redirect_to root_path

        new_order = Order.find_by(id: order.id)
        expect(new_order.status).must_equal "complete"
      end

      it "can change status from complete to paid" do
        old_order = Order.find_by(id: order_complete.id) #ordrussell
        order_hash =   {
          order: {
            merchant_id: fred.id,
            order_id: order_complete.id,
            status: "paid"
          }
        }
        expect {
          patch merchant_ship_path, params: order_hash
        }.wont_change 'Order.count'
        must_respond_with :redirect


        new_order = Order.find_by(id: order_complete.id)
        expect(new_order.status).must_equal "paid"
      end


      it "gives an error if merchant doesn't have that order" do
        order_hash =   {
          order: {
            merchant_id: fred.id,
            order_id: order.id,
            status: "complete"
          }
        }
        old_order = Order.find_by(id: order.id) #ordciara
        expect {
          patch merchant_ship_path, params: order_hash
        }.wont_change 'Order.count'
        must_respond_with :not_found

        new_order = Order.find_by(id: order.id)
        expect(new_order.status).must_equal "paid"
      end

      it "gives an error if the order params have invalid status" do
        order_hash =   {
          order: {
            merchant_id: merchant.id,
            order_id: order.id,
            status: "invalidstatus"
          }
        }
        old_order = Order.find_by(id: order.id) #ordciara
        expect {
          patch merchant_ship_path, params: order_hash
        }.wont_change 'Order.count'
        must_respond_with :bad_request

        new_order = Order.find_by(id: order.id)
        expect(new_order.status).must_equal "paid"
      end

      it "will redirect to not found if there's no order" do
        params_hash = {
          order: {
            merchant_id: -1,
            order_id: order.id,
            status: "complete"
          }
        }
        expect{patch merchant_ship_path(params_hash)}.wont_change 'Order.count'
        must_respond_with :not_found
      end
    end
end






end
