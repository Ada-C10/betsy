require "test_helper"

describe OrderItemsController do
  # it "must be a real test" do
  #   flunk "Need real tests"
  # end

  describe 'create action' do
    let(:order) { Order.new }
    let(:existing_product) { Product.first }

    # let(:order_data) {
    #   {
    #     order: {
    #       name: 'Sherlock Holmes',
    #       email: 'smart@ssdetective.com',
    #       address: '221B Baker St, London',
    #       cc_num: 1234567812345678,
    #       cvv: 123,
    #       exp_month: 12,
    #       exp_year: Date.today.year + 1,
    #       zip: 43770
    #     }
    #   }
    # }

    let(:order_item_data) {
      {
        order_item: {
          quantity: 2,
          product_id: existing_product.id
        }
      }
    }

    it 'creates an order_item if cart is empty' do

      order_item_test = OrderItem.new(order_item_data[:order_item])

      order_item_test.wont_be :valid?, "Order data was invalid. Engineer, please fix this test."

      old_orders_count = Order.count
      old_orderItems_count = OrderItem.count

      post order_items_path, params: order_item_data

      expect(Order.count).must_equal old_orders_count + 1
      expect(OrderItem.count).must_equal old_orderItems_count + 1

      must_redirect_to order_path(Order.last)

      expect(OrderItem.last.quantity).must_equal order_item_data[:order_item][:quantity]
      expect(OrderItem.last.order_id).must_equal Order.last.id

    end
  end
end
