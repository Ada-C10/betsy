require "test_helper"

describe OrderItem do
  let(:order_item) { order_items(:line1) }

  describe 'relationships' do
    it 'must belong to a product' do
      product = order_item.product

      expect(product).must_be_instance_of Product
      expect(product.id).must_equal order_item.product.id

    end

    it 'must belong to an order' do
      order = order_item.order

      expect(order).must_be_instance_of Order
      expect(order.id).must_equal order_item.order.id
    end
  end

  describe 'validations' do
    it 'must be valid with all fields' do
      another_order_item = order_items(:line2)

      expect(order_item).must_be :valid?

      expect(another_order_item).must_be :valid?
    end

    it 'must have qty' do
      order_item.qty = nil

      valid = order_item.save

      expect(valid).must_equal false
      expect(order_item.errors.messages).must_include :qty
    end

    it 'must have a quantity greater than 0' do
      order_item.qty = 0

      valid = order_item.save

      expect(valid).must_equal false
      expect(order_item.errors.messages).must_include :qty
    end

    it 'must have a quantity that is an integer' do
      order_item.qty = 1.5

      valid = order_item.save

      expect(valid).must_equal false
      expect(order_item.errors.messages).must_include :qty
    end

  end

  describe 'subtotal' do
    it 'must be able to calculate subtotal for order_item' do
      subtotal = order_item.subtotal

      expect(subtotal).must_equal order_item.product.price * order_item.qty
    end

    it 'must be able to calculate subtotal for order_item with qty of 0' do
      order_item.qty = 0
      order_item.save

      subtotal = order_item.subtotal

      expect(subtotal).must_equal 0
    end

  end



end
