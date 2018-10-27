require "test_helper"

describe Order do

  describe 'relations' do
    it "has a list of order items" do
      order = orders(:one)
      order.must_respond_to :order_items

      order.order_items.each do |order_item|
        order_item.must_be_kind_of  OrderItem
      end
    end
  end

  describe 'validations' do
    before do
      @order = orders(:one)
    end

    it 'is valid when email, mailing, cc, cc_name, ccv and zip is present' do
      is_valid = @order.valid?
      expect( is_valid ).must_equal true
    end

    it 'is invalid when email is missing' do
      @order.email = nil

      is_valid = @order.valid?

      expect( is_valid ).must_equal false

      expect( @order.errors.messages ).must_include :email
    end

    it 'is invalid when mailing address is missing' do
      @order.mailing_address = nil

      is_valid = @order.valid?

      expect( is_valid ).must_equal false
      expect( @order.errors.messages ).must_include :mailing_address
    end

    it 'is invalid when cc is missing' do
      @order.cc = nil

      is_valid = @order.valid?

      expect( is_valid ).must_equal false
      expect( @order.errors.messages ).must_include :cc
    end

    it 'is invalid when cc name is missing' do
      @order.cc_name = nil

      is_valid = @order.valid?

      expect( is_valid ).must_equal false
      expect( @order.errors.messages ).must_include :cc_name
    end

    it 'is invalid when cvv name is missing' do
      @order.cvv = nil

      is_valid = @order.valid?

      expect( is_valid ).must_equal false
      expect( @order.errors.messages ).must_include :cvv
    end

    it 'is invalid when zip is missing' do
      @order.zip = nil

      is_valid = @order.valid?

      expect( is_valid ).must_equal false
      expect( @order.errors.messages ).must_include :zip
    end
  end
end
