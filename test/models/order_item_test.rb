require "test_helper"

describe OrderItem do

  # VALIDATIONS TESTS

  describe 'validations' do
    let(:order_item) { order_items(:order_item_1) }

    it 'is not valid without a product' do

      order_item.product = nil

      expect(order_item).must_be :invalid?
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
      order_item.quantity = "invalid data"

      expect(order_item).must_be :invalid?
    end

    it 'is valid when all fields are present' do
      expect(order_item).must_be :valid?
    end

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


  # MODEL TESTS
  describe 'custom model methods' do
  end



end
