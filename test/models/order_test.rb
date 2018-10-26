require "test_helper"

describe Order do
  let(:order) { Order.new }
  let(:order1) { orders(:order1) }
  let(:order2) { orders(:order2) }

  describe 'relations' do
    it 'has many order items' do
      expect(order1).must_respond_to :order_items

      order1.order_items.each do |order_item|
        expect(order_item).must_be_kind_of OrderItem
      end

      order1.order_items.each do |order_item|
        expect(order_item).must_equal order_items(:orderitem1)
      end
    end
  end

  # TODO: decide/add more validations+testing (cc info, mailing address, etc)
  describe 'validations' do
    it "must be valid" do
      expect(order2).must_be :valid?
    end

    it 'must have an email address' do
      expect(order2.guest_email).must_equal 'me@wnbc.net'
      # test passes as long as it matches what's in the fixtures. Is this a good test?
      expect(order2).must_respond_to :guest_email

    end

    it 'has a name corresponding with the credit card' do
      expect(order2.guest_cc_name).must_equal 'Person Moo'
    end

    it 'has a credit card number with 16 digits' do
      expect(order2.guest_cc_num).must_equal "0987654321098765"

      expect(order2.guest_cc_num.length).must_equal 16
    end

    it 'has a three-digit CVV number' do
      expect(order2.guest_cc_cvv_code).must_equal "321"

      expect(order2.guest_cc_cvv_code.length).must_equal 3
    end

    it 'must have a 5 digit zip code' do
      expect(order2.guest_cc_zip).must_equal "11238"

      expect(order2.guest_cc_zip.length).must_equal 5
    end

    # it 'rejects an invalid order' do
    #   invalid_order = Order.new
    # end
  end
end
