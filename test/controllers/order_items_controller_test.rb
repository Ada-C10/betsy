require "test_helper"

describe OrderItemsController do

  let (:product1) { products(:cake1) }
  let (:product2) { products(:cake3) }

  let (:order_item_hash1) {
    {
      order_item: {
        product_id: product1.id,
        qty: 5
      }
    }
  }

  let (:order_item_hash2) {
    {
      order_item: {
        product_id: product2.id,
        qty: 3
      }
    }
  }

  let (:exceeds_inventory) {
    {
      order_item: {
        product_id: product1.id,
        qty: 8
      }
    }
  }

  let (:update_order_item1) {
    {
      order_item: {
        product_id: product1.id,
        qty: 3
      }
    }
  }

  let (:invalid_data) {
    {
      order_item: {
        product_id: product1.id,
        qty: nil
      }
    }
  }

  describe 'create' do

    it 'can create a new order line item when order does not already exist' do

      orders_before = Order.count

      expect {
        post order_items_path, params: order_item_hash1
      }.must_change 'OrderItem.count', 1

      orders_after = Order.count
      order_id = Order.last.id

      must_respond_with :redirect
      must_redirect_to cart_path(order_id)

      expect(orders_after).must_equal orders_before + 1
      expect(OrderItem.last.product_id).must_equal product1.id
      expect(OrderItem.last.order_id).must_equal order_id
    end

    it 'can create a new order line item to existing order' do

      post order_items_path, params: order_item_hash1
      order_id = Order.last.id

      expect {
        post order_items_path, params: order_item_hash2
      }.must_change 'OrderItem.count', 1

      must_respond_with :redirect
      must_redirect_to cart_path(order_id)
      expect(OrderItem.last.product_id).must_equal product2.id
      expect(OrderItem.last.order_id).must_equal order_id
    end

    it 'can not add a line order item if quantity exceeds inventory' do

      expect {
        post order_items_path, params: exceeds_inventory
      }.wont_change 'OrderItem.count'

      must_respond_with :redirect
      must_redirect_to product_path(product1.id)

    end

  end

  describe 'update' do

    before do
      post order_items_path, params: order_item_hash1
      @order_id = Order.last.id
      @order_item_id = OrderItem.last.id
      @before_qty = OrderItem.find_by(id: @order_item_id).qty
    end

    it 'can update an existing order line item with valid data' do

      expect {
        patch order_item_path(@order_item_id), params: update_order_item1
      }.wont_change 'OrderItem.count'

      after_qty = OrderItem.find_by(id: @order_item_id).qty

      expect(after_qty).must_equal update_order_item1[:order_item][:qty]
      must_respond_with :redirect
      must_redirect_to cart_path(@order_id)

    end

    it 'will not update an existing order line item with invalid data' do

      expect {
        patch order_item_path(@order_item_id), params: invalid_data
      }.wont_change 'OrderItem.count'

      after_qty = OrderItem.find_by(id: @order_item_id).qty

      expect(after_qty).must_equal @before_qty

      must_respond_with :redirect
      must_redirect_to root_path
    end

    it 'will redirect when a line order item does not exist to update' do

      expect {
        patch order_item_path(-1), params: update_order_item1
      }.wont_change 'OrderItem.count'

      must_respond_with :redirect
      must_redirect_to root_path

    end

    it 'will will not update existing order line item when qty exceeds inventory count' do

      expect {
        patch order_item_path(@order_item_id), params: exceeds_inventory
      }.wont_change 'OrderItem.count'

      after_qty = OrderItem.find_by(id: @order_item_id).qty

      expect(after_qty).must_equal @before_qty

      must_respond_with :redirect
      must_redirect_to product_path(product1.id)
    end
  end

  describe 'destroy' do

    before do
      post order_items_path, params: order_item_hash1
      @order_id = Order.last.id
      @order_item_id = OrderItem.last.id
      @before_qty = OrderItem.find_by(id: @order_item_id).qty
    end

    it 'can delete an existing order line item' do

      expect{
        delete order_item_path(@order_item_id)
      }.must_change 'OrderItem.count', -1

      must_respond_with :redirect
      must_redirect_to cart_path(@order_id)
      expect(OrderItem.find_by(id: @order_item_id)).must_be_nil
    end

    it 'will render not_found when a line order item does not exist to delete' do
    end

  end

  describe 'cart_direct' do

    it 'can add a line order item with a qty of 1 when existing order exists' do
      post order_items_path, params: order_item_hash1
      order_id = Order.last.id

      new_item = products(:cake3)

      expect {
        post quick_shop_path(new_item.id)
      }.must_change 'OrderItem.count', 1

      must_respond_with :redirect
      must_redirect_to cart_path(order_id)
      expect(OrderItem.last.product_id).must_equal new_item.id
      expect(OrderItem.last.order_id).must_equal order_id

    end

    it 'can add a line order item with a qty of 1 when existing order does not exist' do

      orders_before = Order.count
      new_item = products(:cake3)

      expect {
        post quick_shop_path(new_item.id)
      }.must_change 'OrderItem.count', 1

      orders_after = Order.count
      order_id = Order.last.id

      must_respond_with :redirect
      must_redirect_to cart_path(order_id)

      expect(orders_after).must_equal orders_before + 1
      expect(OrderItem.last.product_id).must_equal new_item.id
      expect(OrderItem.last.order_id).must_equal order_id
    end

    it 'can not add a line order item if item is out of stock' do
      product = products(:brownie)

      expect {
        post quick_shop_path(product.id)
      }.wont_change 'OrderItem.count'

      must_respond_with :redirect
      must_redirect_to products_path
    end
  end

end
