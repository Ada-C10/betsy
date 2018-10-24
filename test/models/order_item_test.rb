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

    it 'is not valid with a quantity input other than an integer' do
      order_item.quantity = "you should fail"

      expect(order_item).must_be :invalid?
    end

    it 'is valid when all fields are present' do
      expect(order_item).must_be :valid?
    end

  end


  # RELATIONS TESTS
  it 'must relate '



  # MODEL TESTS



end
