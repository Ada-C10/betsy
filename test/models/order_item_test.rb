require "test_helper"

describe OrderItem do
  describe 'relations' do
    before do
      @order_item = OrderItem.first
    end

    it "belongs to a product" do
      product = @order_item.product

      expect( product ).must_be_kind_of Product
    end

    it "belongs to an order" do
      @order_item = OrderItem.first

      order = @order_item.order

      expect( order ).must_be_kind_of Order
    end
  end

  describe 'validations' do
    before do
      @order_item = OrderItem.first
    end

    it 'is valid with product_id present' do
      result = @order_item.valid?
      expect( result ).must_equal true
    end


    it 'is invalid without product_id' do
      @order_item.product_id = nil
      result = @order_item.valid?

      expect( result ).wont_equal true
      expect( @order_item.errors.messages ).must_include :product
    end

    it 'is valid with order_id present' do
      result = @order_item.valid?

      expect( result ).must_equal true
    end

    it 'is invalid without order_id' do
      @order_item.order_id = nil
      result = @order_item.valid?

      expect( result ).wont_equal true
      expect( @order_item.errors.messages ).must_include :order
    end

    it 'is invalid without status' do
      @order_item.status = nil
      result = @order_item.valid?

      expect( result ).wont_equal true
      expect( @order_item.errors.messages ).must_include :status
    end

    it 'is valid with status' do
      result = @order_item.valid?
      expect( result ).must_equal true
    end

    it 'is invalid if quantity is 0' do
      @order_item.quantity = 0
      result = @order_item.valid?

      expect( result ).wont_equal true
      expect( @order_item.errors.messages ).must_include :quantity
    end

    it 'is invalid if quantity is nil' do
      @order_item.quantity = nil
      result = @order_item.valid?

      expect( result ).wont_equal true
      expect( @order_item.errors.messages ).must_include :quantity
    end

    # it 'is invalid if quantity is greater than product inventory' do
    #   @order_item.quantity = 20
    #   result = @order_item.valid?
    #
    #   expect( result ).wont_equal true
    #   expect( @order_item.errors.messages ).must_include :quantity
    # end
  end

end
