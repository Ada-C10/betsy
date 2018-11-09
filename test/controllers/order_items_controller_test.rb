require "test_helper"
require "pry"

describe OrderItemsController do

  describe "create" do

    it "can create an order item with good data" do

      order_item_data = {
          item_id: Item.first.id,
          order_id: Order.first.id,
          quantity_per_item: 1
      }

      new_order_item = OrderItem.new(order_item_data)

      new_order_item.must_be :valid?, "Data was invalid. Please come fix this test."

      expect {
        post item_order_items_path(Item.first.id),
        params: order_item_data
      }.must_change('OrderItem.count', +1)

    end

    it "does not create a new order item with bad data" do

      order_item_data = {
          item_id: Item.first.id,
          order_id: Order.first.id,
          quantity_per_item: nil
      }

      OrderItem.new(order_item_data).wont_be :valid?, "Data wasn't invalid. Please come fix this test."

      expect {
        post item_order_items_path(Item.first.id),
        params: order_item_data
      }.wont_change('OrderItem.count')

    end
  end

  # describe "update" do
  #
  #   it "can update an item's quantity" do
  #
  #     @order = Order.first
  #     @order_item = OrderItem.first
  #
  #     start_count = @order_item.quantity_per_item
  #
  #     order_item_data = {
  #         quantity_per_item: @order_item.quantity_per_item + 1
  #     }
  #
  #     expect {
  #       patch order_item_path(@order_item.id),
  #       params: order_item_data
  #     }.must_change('start_count')
  #
  #   end
  # end

  # describe "destroy" do
  #
  #   it "can destroy an existing order item" do
  #     start_count = OrderItem.count
  #
  #     orderitem = OrderItem.create(
  #       item_id: Item.first.id,
  #       order_id: Order.first.id,
  #       quantity_per_item: 1
  #     )
  #
  #     delete order_item_path(orderitem.id)
  #
  #     expect(OrderItem.count).must_equal start_count
  #
  #   end
  # end

end
