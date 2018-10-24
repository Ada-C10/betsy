require "test_helper"

describe Order do
  let(:order) { Order.first }

  # this was just to test that table data was valid
  it "must be valid" do
    skip
    Order.all.each do |o|
      expect(o.valid?).must_equal true
    end
  end

  describe 'relations' do
    let(:order) { Order.first }

    it 'has some order_items' do
      order.must_respond_to :order_items
      order.order_items.each do |order_item|
        order_item.must_be_kind_of OrderItem
      end
    end

    it 'has some products through order_items' do
      order.must_respond_to :products
      order.products.each do |order_item|
        order_item.must_be_kind_of Product
      end
    end
  end

  describe 'validations' do
    let(:order) {
      Order.new
    }

    let(:order_data) {
      {
        order: {
          name: 'Sherlock Holmes',
          email: 'smart@ssdetective.com',
          address: '221B Baker St, London',
          cc_num: 1234567812345678,
          cvv: 123,
          exp_month: 12,
          exp_year: Date.today.year + 1,
          zip: 43770
        }
      }
    }

    let(:existing_order) {Order.first}
    let(:existing_id) { existing_order.id }

    it 'is valid on create with only id and status recorded' do
      order.valid?.must_equal true
    end
  end

  describe 'subtotal method' do
    it 'returns the sum of all of the order items of this order' do
      order = Order.first

      sum = 0
      order.order_items.each do |o_item|
        sum += o_item.product.price * o_item.quantity
      end

      order.subtotal.must_be_kind_of BigDecimal
      order.subtotal.must_equal sum
    end
  end

  describe 'Class method: tax_rate' do
    it 'returns the constant TAX_RATE formatted to at most the 100ths place' do

      Order.tax_rate.must_be_close_to 10.1

    end
  end

  describe 'total method' do
    it 'returns the sum + tax for this order' do
      order = Order.first

      sum = 0
      order.order_items.each do |o_item|
        sum += o_item.product.price * o_item.quantity
      end
      sum *= (1 + 0.101)

      order.total.must_be_kind_of BigDecimal
      order.total.must_equal sum
    end
  end

  describe 'Class method: months' do
    it 'returns an array from 1 through 12' do
      expected_array = [*1..12]

      Order.months.must_equal expected_array

    end
  end

  describe 'Class method: years' do
    it 'returns an array of 30 years starting from the current year' do
      result = Order.years

      result.first.must_equal Date.today.year
      result.last.must_equal Date.today.year + 29
      result.length.must_equal 30

    end
  end

  describe 'Class method: get_current_month' do
    it 'returns the current month' do
      result = Order.get_current_month

      result.must_equal Date.today.month
    end
  end

  describe 'Class method: get_current_year' do
    it 'returns the current year' do
      result = Order.get_current_year

      result.must_equal Date.today.year
    end
  end

  describe 'validate method' do
    it 'raises an ArgumentError if exp_year or exp_month are nil' do


    end
  end

end
