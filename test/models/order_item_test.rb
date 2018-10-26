require "test_helper"


describe OrderItem do
  let(:order_item) { OrderItem.new }
  let(:orderitem1) { order_items(:orderitem1) }

  describe 'relations' do
    it 'belongs to a product' do
      expect(orderitem1).must_respond_to :product
      expect(orderitem1.product).must_be_kind_of Product
      # expect(orderitem1.product).must_equal products(:poodr)
    end

    it 'belongs to an order' do
      expect(orderitem1).must_respond_to :order
      expect(orderitem1.order).must_be_kind_of Order
      expect(orderitem1.order).must_equal orders(:order1)
    end
  end

  describe 'validations' do
    it "must be valid" do
      value(orderitem1).must_be :valid?
    end

    it 'must have a quantity present' do
      expect(orderitem1.valid?).must_equal true
      p orderitem1.quantity

      orderitem1.quantity = nil

      expect(orderitem1.valid?).must_equal false
      expect(orderitem1.errors.messages).must_include :quantity
    end

    it 'must have a quantity greater than zero present' do
      orderitem1.quantity = 0

      expect(orderitem1.valid?).must_equal false
      expect(orderitem1.errors.messages).must_include :quantity

      orderitem1.quantity = -1

      expect(orderitem1.valid?).must_equal false
      expect(orderitem1.errors.messages).must_include :quantity
    end

    it 'must have an integer present' do
      orderitem1.quantity = 1.5

      expect(orderitem1.valid?).must_equal false
      expect(orderitem1.errors.messages).must_include :quantity

      orderitem1.quantity = "number"

      expect(orderitem1.valid?).must_equal false
      expect(orderitem1.errors.messages).must_include :quantity
    end

    it 'must have a shipping status present' do
      orderitem1.shipped = nil

      expect(orderitem1.valid?).must_equal false
      expect(orderitem1.errors.messages).must_include :shipped
    end

    # it 'must have a valid shipping status' do
    #   orderitem1.shipped = "string"
    #
    #   expect(orderitem1.valid?).must_equal false
    #   expect(orderitem1.errors.messages).must_include :shipped
    # end
  end

  describe 'model logic' do
    # TODO: add tests for business logic below
  end
end
