require "test_helper"
describe Orderproduct do

  describe "relationships" do
    before do
      @orderproduct1 = orderproducts(:orderproduct1)
    end

    it "has a product" do
      @orderproduct1.must_respond_to :product
      @orderproduct1.product.must_be_kind_of Product
    end

    it "has an order" do
      @orderproduct1.must_respond_to :order
      @orderproduct1.order.must_be_kind_of Order
    end

  end

  describe "validations" do

    before do
      @goat = products(:goat)
      @order = orders(:complete_order)
    end

    it "allows the two valid statuses" do
      valid_statuses = ['pending', 'shipped']
      valid_statuses.each do |status|
        orderproduct = Orderproduct.new(status: status, quantity: 1, order_id: @order.id, product_id: @goat.id)
        orderproduct.valid?.must_equal true
      end
    end

    it "rejects invalid statuses" do
      invalid_statuses = ['cat', 'dog', 'phd thesis', 1337, nil]
      invalid_statuses.each do |status|
        orderproduct = Orderproduct.new(status: status, quantity: 1, order_id: @order.id, product_id: @goat.id)
        orderproduct.valid?.must_equal false
        orderproduct.errors.messages.must_include :status
      end
    end

    it "requires a status" do
      orderproduct = Orderproduct.new(quantity: 1, order_id: @order.id, product_id: @goat.id)
      orderproduct.valid?.must_equal false
      orderproduct.errors.messages.must_include :status
    end

    it "requires a quantity" do
      orderproduct = Orderproduct.new(status: "pending", order_id: @order.id, product_id: @goat.id)
      orderproduct.valid?.must_equal false
      orderproduct.errors.messages.must_include :quantity
    end

    it "a quantity needs to be an integer" do
      orderproduct = Orderproduct.new(status: "pending", quantity: "hello", order_id: @order.id, product_id: @goat.id)
      orderproduct.valid?.must_equal false
      orderproduct.errors.messages.must_include :quantity
    end

    it "a quantity needs to be greater than 0" do
      orderproduct = Orderproduct.new(status: "pending", quantity: -1, order_id: @order.id, product_id: @goat.id)
      orderproduct.valid?.must_equal false
      orderproduct.errors.messages.must_include :quantity
    end

    it "a quantity needs to be equal or less than an orderproduct's product's stock count" do
      orderproduct = Orderproduct.create(status: "pending", quantity: -1, order_id: @order.id, product_id: @goat.id)
      orderproduct.valid?.must_equal false
      orderproduct.errors.messages.must_include :quantity

      orderproduct = Orderproduct.new(status: "pending", quantity: 100, order_id: @order.id, product_id: @goat.id)
      orderproduct.valid?.must_equal false
      orderproduct.errors.messages.must_include :quantity

      orderproduct = Orderproduct.new(status: "pending", quantity: 15, order_id: @order.id, product_id: @goat.id)
      orderproduct.valid?.must_equal true

      orderproduct = Orderproduct.new(status: "pending", quantity: 5, order_id: @order.id, product_id: @goat.id)
      orderproduct.valid?.must_equal true
    end

    it "requires an order_id" do
      orderproduct = Orderproduct.new(quantity: 1, status: "pending", product_id: @goat.id)
      orderproduct.valid?.must_equal false
      orderproduct.errors.messages.must_include :order_id
    end

    it "requires an product_id" do
      orderproduct = Orderproduct.new(quantity: 1, status: "pending", order_id: @order.id)
      orderproduct.valid?.must_equal false
      orderproduct.errors.messages.must_include :product_id
    end

  end

  describe "create_product_orders" do
    before do
      @order = Order.create(name: "Judy Poacher", email: "fake@fake.com", mailing_address: "1234 USA Main Street", zip_code: 12345, cc_number: 8295838304727592, cc_expiration: 1155, cc_cvv: 476, status: "pending", total_cost: 700.00)
      @lamb = products(:lamb)
      @goat = products(:lamb)
      @session_cart = [{@lamb.id=>3}, {@goat.id=>3}]
    end

    it "creates orderproducts" do
      expect(@order.orderproducts.length.must_equal 0)

      Orderproduct.create_product_orders(@order.id, @session_cart)

      Orderproduct.all.each do |orderproduct|
        @order.orderproducts << orderproduct if orderproduct.order.id == @order.id
      end

      expect(@order.orderproducts.length.must_equal @session_cart.length)

      @order.orderproducts.each do |orderproduct|
        expect(orderproduct.order.id.must_equal @order.id)
        expect(orderproduct.product.id.must_equal @goat.id || @lamb.id)
        orderproduct.valid?.must_equal true
        orderproduct.must_be_kind_of Orderproduct
      end
    end

    it "doesnt create an orderproduct if there isn't enough stock" do
      large_session_cart = [{@lamb.id=>100}]

      expect {
        Orderproduct.create_product_orders(@order.id, large_session_cart)
      }.wont_change 'Orderproduct.all.length'
    end
  end

end
