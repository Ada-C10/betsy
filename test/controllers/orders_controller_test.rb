require "test_helper"

describe OrdersController do

  # it "must be a real test" do
  #   flunk "Need real tests"
  # end
  describe "index" do

     it "shows order belonging to merchant" do
       merchant = :mercury
       login_test_user

       get merchant_orders_path(merchant)
       must_respond_with :success
     end

      it "only merchant can view orders" do
       merchant = :mercury

       get merchant_orders_path(merchant)
       must_redirect_to root_path
     end

   end


  describe "show" do

   it "returns success with valid id when logged in" do
     login_test_user

     order_id = Order.first.id

     get order_path(order_id)
     must_respond_with :success
   end

 end


end
