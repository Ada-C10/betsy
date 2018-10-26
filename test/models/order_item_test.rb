require "test_helper"

describe OrderItem do
  before do
    @o = order_items(:one)
  end
  describe 'relations' do
    it 'has a product' do

      expect( @o.product ).must_be_instance_of Product

    end

    it 'has an order' do

      expect( @o.order ).must_be_instance_of Order

    end
  end

  describe 'validations' do
    it 'is valid when quantity and status are present with valid values' do

      expect( @o ).must_be :valid?

    end

    it 'is invalid without a quantity' do

      @o.quantity = nil

      expect( @o ).wont_be :valid?

    end

    it 'is invalid with a quantity of 0 or less' do

      @o.quantity = 0

      expect( @o ).wont_be :valid?

      @o.quantity = -1

      expect( @o ).wont_be :valid?
    end

    it 'is invalid without a status' do

      @o.status = nil

      expect( @o ).wont_be :valid?

    end

    it 'is invalid when the status is not one of the valid status values' do

      @o.status = 'foo'

      expect( @o ).wont_be :valid?

    end

  end

  describe 'price' do
    it 'correctly calculates price based on product price and quantity' do
      o = order_items(:five)

      expect( o.price).must_be_close_to 5.97, 0.01
    end
  end

end
