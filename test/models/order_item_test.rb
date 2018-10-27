require "test_helper"

describe OrderItem do

  # VALIDATIONS TESTS
  describe 'validations' do
    let(:order_item) { order_items(:order_item_1) }

    it 'is not valid without a product' do
      order_item.product_id = nil

      expect(order_item).must_be :invalid?
      expect
    end

    it 'is not valid without an order' do

      order_item.order = nil

      expect(order_item).must_be :invalid?
    end

    it 'is not valid without a quantity' do

      order_item.quantity = nil

      expect(order_item).must_be :invalid?

    end

    it 'is not valid with a quantity less than 0' do
      order_item.quantity = -10

      expect(order_item).must_be :invalid?
    end

    it 'is not valid with a quantity equal to 0' do
      order_item.quantity = 0

      expect(order_item).must_be :invalid?

    end

    it 'is not valid with a quantity input other than an integer' do
      order_item.quantity = "you should fail"

      expect(order_item).must_be :invalid?
    end

    it 'is valid when all fields are present' do
      expect(order_item).must_be :valid?
    end


    it 'is not valid when quantity exceeds product inventory' do
      stock = order_item.product.inventory

      order_item.quantity = stock + 1

      expect(order_item).must_be :invalid?
    end


    # RELATIONS TESTS
    describe 'relations' do
      let(:order_item) { order_items(:order_item_6) }

      # products
      it 'must relate to a product' do

        expect(order_item).must_respond_to :product
        expect(order_item.product).must_equal products(:thyme)
      end

      it 'can set the product via product instance' do

        new_item = OrderItem.new(quantity: 1, order: orders(:order_two))

        new_item.product = products(:steak)

        expect(new_item.product_id).must_equal products(:steak).id
      end

      it 'can set the product via product id' do

        new_item = OrderItem.new(quantity: 1, order: orders(:order_two))

        new_item.product_id = products(:steak).id

        expect(new_item.product).must_equal products(:steak)
      end

      # orders
      it 'must relate to an order' do

        expect(order_item).must_respond_to :order
        expect(order_item.order).must_equal orders(:order_three)
      end

      it 'can set the order via order instance' do
        new_item = OrderItem.new(quantity: 1, product: products(:taco))

        new_item.order_id = orders(:order_two).id

        expect(new_item.order).must_equal orders(:order_two)
      end

      it 'can set the order via order id' do
        new_item = OrderItem.new(quantity: 1, product: products(:taco))

        new_item.order = orders(:order_two)

        expect(new_item.order_id).must_equal orders(:order_two).id
      end
    end
  end


  # MODEL TESTS
  describe 'custom model methods' do

    let(:order_item) { order_items(:order_item_1) }

    describe 'available_stock' do
      it 'must return an array of Integers from 1 to the associated product inventory' do
        stock = order_item.product.inventory
        result = order_item.available_stock

        expect(result).must_respond_to :each
        expect(result.first).must_equal 1
        expect(result.last).must_equal stock
      end

      it 'must return nil if associated product inventory is less than 1' do
        order_item.product.inventory = 0
        expect(order_item.available_stock).must_equal [0]
      end
    end

    describe 'item_total' do
      it 'must return the line item total for an order_item' do
        product = order_item.product.price
        quantity = order_item.quantity

        expected_result = product * quantity

        expect(order_item.item_total).must_equal expected_result
      end
    end

    describe 'product_name' do
      it 'must return the name of the product' do
        name = order_item.product.name

        expect(order_item.product_name).must_equal name
      end
    end

    describe 'order_status' do
      it 'must return the status of the product' do
        status = order_item.order.status

        expect(order_item.order_status).must_equal status
      end
    end
  end
end
