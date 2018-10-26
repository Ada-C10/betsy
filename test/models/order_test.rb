require "test_helper"

describe Order do
  before do
    @o = orders(:bob)
  end
  describe 'relations' do


    it 'has some order items' do
      expect( @o.order_items ).must_respond_to :each

      @o.order_items.each do |order_item|
        expect(order_item).must_be_instance_of OrderItem
      end
    end


  end

  describe 'validations' do
    describe 'conditional validation: order is not pending' do

      it 'is valid when all required fields are present' do
        expect( @o ).must_be :valid?

      end

      it 'is invalid without a name' do

        @o.name = nil

        expect( @o ).wont_be :valid?

      end

      it 'is invalid without an email' do

        @o.email = nil

        expect( @o ).wont_be :valid?

      end

      it 'is invalid without an address' do

        @o.address = nil

        expect( @o ).wont_be :valid?

      end

      it 'is invalid without a cc_num' do

        @o.cc_num = nil

        expect( @o ).wont_be :valid?

      end

      it 'is invalid without a cc_cvv' do

        @o.cc_cvv = nil

        expect( @o ).wont_be :valid?

      end

      it 'is invalid without a cc_expiration' do

        @o.cc_expiration = nil

        expect( @o ).wont_be :valid?

      end
    end

    describe 'unconditional validation' do

      before do
        @o = orders(:incomplete_order)
      end

      it 'is valid if status is present and true' do
        expect( @o ).must_be :valid?
      end

      it 'is invalid if status is not a valid status' do
        @o.status = 'foo'

        expect( @o ).wont_be :valid?
      end
    end

  end

  describe 'is_not_pending' do
    it 'returns false if pending' do
      @o.status = 'pending'

      expect( @o.is_not_pending ).must_equal false
    end

    it 'returns true if not pending' do

      Order::STATUS.each do |status|
        if status != 'pending'
          @o.status = status

          expect( @o.is_not_pending ).must_equal true
        end
      end

    end
  end

  describe 'total' do
    it 'returns total price of all order items' do

      expect( @o.total ).must_be_close_to 39.93, 0.01
    end

    it 'returns 0 if no order items' do

      @o.order_items.each do |order_item|
        order_item.destroy
      end

      @o.reload

      expect( @o.total ).must_equal 0

    end

  end
  describe 'CC_num_last_four' do
    it 'correctly returns last four digits of cc_num' do
      @o.cc_num = '1239082378923'

      expect( @o.CC_num_last_four ).must_equal '8923'
    end

    it 'returns total string if cc_num length is less than 4' do
      @o.cc_num = '13'

      expect( @o.CC_num_last_four ).must_equal '13'
    end

    it 'returns nil if cc_num is nil' do
      @o.cc_num = nil

      expect( @o.CC_num_last_four ).must_be_nil
    end
  end

  describe 'total_quantity' do
    it 'returns total quantity of all order items' do

      expect( @o.total_quantity ).must_equal 7
    end

    it 'returns 0 if no order items' do

      @o.order_items.each do |order_item|
        order_item.destroy
      end

      @o.reload

      expect( @o.total_quantity ).must_equal 0

    end
  end

  describe 'paid' do
    it 'successfully sets own status and all order items status to paid' do
      @o.status = 'pending'

      @o.order_items.each do |order_item|
        order_item.status = 'pending'
      end

      @o.set_paid

      expect( @o.status ).must_equal 'paid'

      @o.order_items.each do |order_item|
        expect( order_item.status ).must_equal 'paid'
      end
    end
  end
end
