require "test_helper"

describe OrderItem do

  # VALIDATIONS TESTS
  describe 'validations' do
    let(:order_item) { order_items(:order_item_1) }

    it 'is not valid without a product' do

      order_item.product = nil

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

    # Controller
    it 'is able to set multiple quantities of the a product to an order_item' do
      product_1 = products(:pickle)

      new_item = OrderItem.new(quantity: 1, order: orders(:order_two))
      order_item.product = product_1
      order_item.product = product_1
      order_item.product = product_1

      expect(order_item).must_be :valid
      expect(order_item.products).must_equal [product1, product1, product1]
      end

    end

    # Controller?
    it 'does not assign more than one unique product to an order_item' do
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
    let(:order_item) { order_items(:order_item_4) }

    describe 'available_stock' do
      it "returns the correct array of an order item's product inventory" do

      inventory = order_item.available_stock

      expect(inventory).must_equal (1..10).to_a
      end
    end


    describe 'item_total' do
      it 'returns the order_item total' do

        item_total = order_item.item_total

        expect(item_total).must_equal 7000

      end

    end

    describe 'product_name' do
      it "returns the correct name for an order_item's product" do
        name = order_item.product_name

        expect(name).must_equal "Sherbet"
      end
    end

    describe 'order_status' do
      it 'returns the correct order status from an order_item' do
        status = order_item.order_status

        expect(status).must_equal 'paid'
      end
    end

    # TODO is this total subtotal? there's another method on Order for total

    describe 'total' do
      # it 'returns the correct total of an order_item with tax' do
      #   total = order_item.total
      #
      #   expect(total).must_equal
      # end
    end

    describe 'cant_exceed_inventory' do

    end


  end



end
