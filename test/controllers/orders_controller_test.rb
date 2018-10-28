require "test_helper"

describe OrdersController do

  describe "new" do
    it "succeeds" do
      get new_order_path

      must_respond_with :success
    end
  end

  describe "create" do
    let (:order_hash) do
      {
        order: {
          name: 'Susie Smiths',
          email: 'testemail@gmail.com',
          mailing_address: '4150 Delridge Way SW',
          zip_code: 44903,
          cc_number: 8275928304958372,
          cc_expiration: '04/21',
          cc_cvv: 843,
          status: 'pending',
          total_cost: 8000
        }
      }
    end

    let (:bad_params) do
      {
        order: {
          name: nil,
          email: nil,
          mailing_address: nil,
          zip_code: 44903,
          cc_number: 8275928304958372,
          cc_expiration: '04/21',
          cc_cvv: 843,
          status: nil,
          total_cost: 8000
        }
      }
    end

    before do
      @lamb = products(:lamb)
      @quantity_hash = { quantity: "3" }
      @duckling = products(:duckling)
      @quantity_hash2 = { quantity: "2" }
      @unicorn = products(:unicorn)
      @quantity_hash3 = { quantity: "1" }
    end

    it "creates an order with paid status" do
      # adds things so session[:cart]
      post add_to_cart_path(@lamb.id), params: @quantity_hash
      post add_to_cart_path(@duckling.id), params: @quantity_hash2

      expect {
        post orders_path, params: order_hash
      }.must_change 'Order.count', 1

      must_respond_with :redirect
      expect(flash[:success]).must_equal "Adoption request successfully placed! (Order ##{Order.last.id})"
      expect(Order.last.status).must_equal 'paid'
    end

    it "fails to create order when a product in the session goes out of stock" do

      post add_to_cart_path(@lamb.id), params: @quantity_hash
      post add_to_cart_path(@duckling.id), params: @quantity_hash2
      post add_to_cart_path(@unicorn.id), params: @quantity_hash3
      @unicorn.update(stock_count: 0)
      @unicorn.save

      expect {
        post orders_path, params: order_hash
      }.wont_change 'Order.count'

      expect(flash[:danger]).wont_be_nil
      must_respond_with :redirect
    end

    it "won't create an order without the needed buyers information" do
      post add_to_cart_path(@lamb.id), params: @quantity_hash
      post add_to_cart_path(@duckling.id), params: @quantity_hash2

      expect {
        post orders_path, params: bad_params
      }.wont_change 'Order.count'

      expect(flash[:messages]).must_include :name, :email
      must_respond_with :bad_request
      #won't create orphaned Orderproducts
      expect(Orderproduct.last.order_id).wont_be_nil
    end
  end

  describe "new" do
    it "succeeds" do
      get new_order_path

      must_respond_with :success
    end
  end

  describe "show" do
    it "displays a given order" do
      id = orders(:complete_order).id
      get order_path(id)
      must_respond_with :success
    end
  end

  describe "update" do
    let (:order_params) do
      {
        order: {
          name: 'No OrderProducts McGee',
          email: 'testemail@gmail.com',
          mailing_address: '4150 Delridge Way SW',
          zip_code: 44903,
          cc_number: 8275928304958372,
          cc_expiration: '04/21',
          cc_cvv: 843,
          status: 'completed',
          total_cost: 8000
        }
      }
    end
    let (:bad_params) do
      {
        order: {
          name: nil,
          email: nil,
          mailing_address: nil,
          zip_code: 44903,
          cc_number: 8275928304958372,
          cc_expiration: '04/21',
          cc_cvv: 843,
          status: nil,
          total_cost: 8000
        }
      }
    end
    it "succeeds in updating order status" do
      id = orders(:complete_order).id

      expect {
        patch order_path(id), params: order_params
      }.wont_change 'Order.count'

      must_respond_with :redirect
      must_redirect_to order_path(id)

      expect(Order.find(id).status).must_equal order_params[:order][:status]
    end

    it "renders bad_request when given nil update data" do
      id = orders(:complete_order).id

      expect {
        patch order_path(id), params: bad_params
      }.wont_change 'Order.count'

      must_respond_with :redirect
      expect(Order.find(id).name).must_equal "Monique Marie"
      expect(flash[:danger]).must_equal "Adoption request was not updated."
    end
  end
  # => <ActionController::Parameters {"controller"=>"orders", "action"=>"show", "id"=>"5"} permitted: false>

  describe "search" do
    it "allows a user to input an order number and display order" do

      complete_order = orders(:complete_order)
      order_num_params = {"id"=> complete_order.id.to_s}

      get search_orders_path, params: order_num_params
      must_respond_with get order_path(complete_order.id)
    end

    it "fails with invalid id" do

      order_num_params = {"id"=> "hello"}

      get search_orders_path, params: order_num_params
      assert_response :not_found
      expect(flash.keys).must_equal ["danger"]
    end
  end

  describe "fulfillment methods" do
    let(:tan) { users(:tan) }


    it "blocks all fulfillment pages if user is not signed in" do
      get get_orders_path
      must_redirect_to root_path
      expect(flash[:danger]).must_equal "Sorry, the fulfillment page is only for creature rescuers."

      get cancelled_orders_path
      must_redirect_to root_path

      get paid_orders_path
      must_redirect_to root_path

      get completed_orders_path
      must_redirect_to root_path
    end

    it "retrieves all orders and total cost" do
      expect {perform_login(tan)}.wont_change('User.count')
      get get_orders_path

      must_respond_with :success
    end

    it "retrieves paid orders and total cost" do
      expect {perform_login(tan)}.wont_change('User.count')
      get paid_orders_path

      must_respond_with :success
    end

    it "retrieves cancelled orders and total cost" do
      expect {perform_login(tan)}.wont_change('User.count')
      get cancelled_orders_path

      must_respond_with :success
    end

    it "retrieves cancelled orders and total cost" do
      expect {perform_login(tan)}.wont_change('User.count')
      get completed_orders_path

      must_respond_with :success
    end

  end
end
