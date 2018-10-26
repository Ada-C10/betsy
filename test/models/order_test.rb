require "test_helper"

describe Order do

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
          zip: 43770,
          status: 'awaiting confirmation'
        }
      }
    }

    let(:existing_order) {Order.first}
    let(:existing_id) { existing_order.id }

    it 'is valid on create with only id and status recorded' do
      order.valid?.must_equal true
    end

    it 'is invalid without a status' do
      order = Order.create(order_data[:order])
      x = Order.update(order.id, status: nil)
      x.status.must_be_nil
      x.valid?.must_equal false
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

  describe 'taxes method' do
    it 'returns the taxes for the order subtotal' do
      order = Order.first

      sum = 0
      order.order_items.each do |o_item|
        sum += o_item.product.price * o_item.quantity
      end

      expected_result = sum * 0.101

      order.taxes.must_be_close_to expected_result

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

  describe 'validate method: cant_be_expired' do

    let(:order_data) {
      {
        order: {
          name: 'Sherlock Holmes',
          email: 'smart@ssdetective.com',
          address: '221B Baker St, London',
          cc_num: 1234567812345678,
          cvv: 123,
          exp_month: Date.today.month,
          exp_year: Date.today.year+1,
          zip: 43770,
          status: 'paid'
        }
      }
    }

    let(:good_month)  { Date.today.month + 1 }
    let(:bad_year) { Date.today.year - 1 }
    let(:bad_month)  { Date.today.month - 1 }
    let(:order) {Order.create}

    it 'succeeds if given an expiration month and year than indicates a non-expired card' do

      order = Order.create(order_data[:order])
      x = Order.update(order.id, exp_month: good_month)

      expect(x.errors.messages).must_be_empty
    end

    it 'raises an ArgumentError only on update if exp_year or exp_month are nil' do

      order.must_be :valid?, "Order params have some invalid parameters. Please fix."

      expect{Order.update(order.id, exp_month: nil)}.must_raise ArgumentError
      expect{Order.update(order.id, exp_year: nil)}.must_raise ArgumentError

    end

    it 'adds messages to errors only on update if exp_year indicates an expired credit card' do
      order_data[:order][:exp_month] = good_month
      order = Order.create(order_data[:order])

      x = Order.update(order.id, exp_year: bad_year)
      expect(x.errors.messages).must_include :exp_year
    end

    it 'adds messages to errors only on update if exp_year and exp_month indicates an expired credit card' do
      order_data[:order][:exp_year] = Date.today.year
      order = Order.create(order_data[:order])

      x = Order.update(order.id, exp_month: bad_month)
      expect(x.errors.messages).must_include :exp_month
    end
  end

  describe 'Class method search' do

    let(:order) { Order.first }
    let(:id) {order.id}
    let(:email) {order.email}

    it 'returns an array of length 1 with the instance of Order that matches both search parameters' do
      found_record = Order.search(id, email)
      expect(found_record.length).must_equal 1
      expect(found_record[0]).must_equal order
    end

    it 'returns an empty array when there is no match in the database' do
      found_record = Order.search(0, 'fake@email.com')
      expect(found_record).must_be_empty
    end
  end

  describe 'get_cc' do
    it 'returns a string of a 16 digit number formatted like XXXX-XXXX-XXXX-1111' do
      order = Order.first
      cc = order.cc_num.to_s

      expect(order.get_cc).must_equal "XXXX-XXXX-XXXX-#{cc[-4..-1]}"



    end
  end


end
