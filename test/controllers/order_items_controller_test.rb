require "test_helper"

describe OrderItemsController do

  describe 'create action' do
    let(:order) { Order.new }
    let(:existing_product) { Product.first }

    let(:order_item_data) {
      {
        id: existing_product.id,

        order_item: {
          quantity: 2,
          product_id: existing_product.id
        }
      }
    }

    let(:order_item_data_2) {
      {
        id: Product.last.id,

        order_item: {
          quantity: 2
        }
      }
    }

    it 'creates an order_item and order if cart is empty' do
      order_item_test = OrderItem.new(order_item_data[:order_item])


      order_item_test.wont_be :valid?, "Order data was valid. Engineer, please fix this test."

      old_orders_count = Order.count
      old_orderItems_count = OrderItem.count

      post order_items_path, params: order_item_data

      expect(Order.count).must_equal old_orders_count + 1
      expect(OrderItem.count).must_equal old_orderItems_count + 1

      must_redirect_to order_path(Order.last)

      expect(OrderItem.last.quantity).must_equal order_item_data[:order_item][:quantity]
      expect(OrderItem.last.order_id).must_equal Order.last.id
    end

    it 'creates an order_item if cart is not empty, associates it with the in-progress order and does not create a new order' do

      post order_items_path, params: order_item_data
      cart = Order.last
      old_orders_count = Order.count

      expect {
        post order_items_path, params: order_item_data_2
      }.must_change('OrderItem.count', +1)

      must_redirect_to order_path(Order.last)

      expect(Order.count).must_equal old_orders_count
      expect(OrderItem.last.order_id).must_equal cart.id

    end

    it 'returns bad request if given invalid data and cart exists' do

      post order_items_path, params: order_item_data
      cart = Order.last
      old_orders_count = Order.count

      order_item_data_2[:order_item][:quantity] = 0

      expect {
        post order_items_path, params: order_item_data_2
      }.wont_change('OrderItem.count')

      must_respond_with 302
      expect(flash[:messages]).must_include :quantity

    end
  end

  describe 'update action' do
    let(:order) { Order.new }
    let(:existing_product) { Product.first }

    let(:order_item_data) {
      {
        id: existing_product.id,

        order_item: {
          quantity: 2,
          product_id: existing_product.id
        }
      }
    }

    let(:order_item_setup) {
      post order_items_path, params: order_item_data
    }

    let(:old_orders_count) { Order.count }
    let(:old_orderItems_count) { OrderItem.count }
    let(:item) { OrderItem.last }
    let(:max_quantity) { item.product.inventory }

    it 'successfully updates an order_item with valid input and redirects to the shopping cart' do
      order_item_setup

      order_item_data[:order_item][:quantity] = max_quantity

      put order_item_path(item), params: order_item_data

      must_redirect_to order_path(item.order)

      expect(Order.count).must_equal old_orders_count
      expect(OrderItem.count).must_equal old_orderItems_count
      expect(OrderItem.last.quantity).must_equal max_quantity
      expect(flash[:result_text]).must_include "Successfully updated order for # #{item.product.name}."
    end

    it 'does not update an order_item with invalid data and redirects back to last page' do
      order_item_setup

      old_quantity = order_item_data[:order_item][:quantity]
      order_item_data[:order_item][:quantity] = max_quantity + 1

      put order_item_path(item), params: order_item_data

      must_respond_with 302

      expect(Order.count).must_equal old_orders_count
      expect(OrderItem.count).must_equal old_orderItems_count
      expect(OrderItem.last.quantity).must_equal old_quantity
      expect(flash[:result_text]).must_include "Something went wrong: Could not update order ##{item.id}"
      expect(flash[:messages]).must_include :quantity
    end

    it 'responds with bad_request if attempting to update an order_item that does not belong to the cart of the current user' do
      order_item_setup

      # Arrange: First OrderItem is not associated with current user
      item = OrderItem.first

      put order_item_path(item), params: order_item_data

      must_respond_with :bad_request
    end

    it 'responds with bad_request if attempting to update an order_item when the cart is empty' do
      # Arrange: First OrderItem is not associated with current user
      item = OrderItem.first

      put order_item_path(item), params: order_item_data

      must_respond_with :bad_request
    end
  end

  describe 'destroy action' do

    let(:order) { Order.new }
    let(:existing_product) { Product.first }

    let(:order_item_data) {
      {
        id: existing_product.id,

        order_item: {
          quantity: 2,
          product_id: existing_product.id
        }
      }
    }

    let(:order_item_setup) {
      post order_items_path, params: order_item_data
    }

    let(:old_orders_count) { Order.count }
    let(:old_orderItems_count) { OrderItem.count }
    let(:item) { OrderItem.last }
    let(:max_quantity) { item.product.inventory }

    it "successfully destroys an order item that is in the user's cart" do
      order_item_setup
      cart = item.order

      expect{
        delete order_item_path(item.id)
      }.must_change('OrderItem.count', -1)

      must_redirect_to order_path(cart)

    end

    it "responds with 404 not_found if order item does not exist" do
      order_item_setup
      delete order_item_path(item.id)

      expect{
        delete order_item_path(item.id)
      }.wont_change('OrderItem.count')

      must_respond_with :bad_request
    end

    it "responds with bad_request if order item does not belong in current cart" do
      order_item_setup
      cart = item.order

      expect{
        delete order_item_path(OrderItem.first)
      }.wont_change('OrderItem.count')

      must_respond_with :bad_request

    end

    it "responds with bad_request if cart is empty" do
      expect{
        delete order_item_path(OrderItem.first)
      }.wont_change('OrderItem.count')

      must_respond_with :bad_request
    end
  end

  describe 'ship action' do

    let(:order) { Order.new }
    let(:existing_product) { Product.first }

    let(:order_item_data) {
      {
        id: existing_product.id,

        order_item: {
          quantity: 2,
          product_id: existing_product.id
        }
      }
    }

    let(:order_item_setup) {
      post order_items_path, params: order_item_data
    }

    let(:old_orders_count) { Order.count }
    let(:old_orderItems_count) { OrderItem.count }
    let(:item) { OrderItem.last }
    let(:max_quantity) { item.product.inventory }

    it 'changes the status of an order from shipped to not shipped and vice versa' do

      item = OrderItem.first
      original_status = item.status

      post ship_path(item.id)

      must_respond_with 302
      item = OrderItem.find(item.id)
      expect(item.status).must_equal !original_status

      post ship_path(item.id)

      must_respond_with 302
      item = OrderItem.find(item.id)
      expect(item.status).must_equal original_status

    end

  end

end
