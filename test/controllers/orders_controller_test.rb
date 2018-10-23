require "test_helper"

describe OrdersController do
  # it "must be a real test" do
  #   flunk "Need real tests"
  # end

  it 'must friggin work' do
    skip
    get root_path
    must_respond_with :success
  end

  describe 'validations on update action' do
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

    it "is valid on update with properly formatted and completed fields: name, email, address, zip, cvv, exp_month, exp_year, and cc_num; changes the status to 'awaiting confirmation'; and redirects to the finalize page" do
      order_test = Order.new(order_data[:order])

      order_test.must_be :valid?, "Order data was invalid. Engineer, please fix this test."

      expect {
        put order_path(existing_id), params: order_data
      }.wont_change('Order.count')

      must_redirect_to finalize_path(existing_id)

      order = Order.find_by(id: existing_id)
      expect(order.status).must_equal 'awaiting confirmation'

      expect(order.name).must_equal order_data[:order][:name]
      expect(order.email).must_equal order_data[:order][:email]
      expect(order.address).must_equal order_data[:order][:address]
      expect(order.cc_num).must_equal order_data[:order][:cc_num]
      expect(order.cvv).must_equal order_data[:order][:cvv]
      expect(order.exp_month).must_equal order_data[:order][:exp_month]
      expect(order.exp_year).must_equal order_data[:order][:exp_year]
      expect(order.zip).must_equal order_data[:order][:zip]

    end

    it 'renders bad request on update if missing credit card information' do

      order.valid?.must_equal true
      order.save

      order_data[:order][:cc_num] = nil

      expect {
        patch order_path(order), params: order_data
      }.wont_change('Order.count')

      must_respond_with :bad_request
      expect(order.cc_num).must_be_nil

    end

    it 'renders bad request on update if credit card number length is not 16' do

      order.valid?.must_equal true
      order.save

      order_data[:order][:cc_num] = [*1..15]

      expect {
        patch order_path(order), params: order_data
      }.wont_change('Order.count')

      must_respond_with :bad_request
      expect(order.cc_num).must_be_nil

      order_data[:order][:cc_num] = [*1..17]

      expect {
        patch order_path(order), params: order_data
      }.wont_change('Order.count')

      must_respond_with :bad_request
      expect(order.cc_num).must_be_nil

    end

    it 'renders bad request on update if missing name' do

      order.valid?.must_equal true
      order.save

      order_data[:order][:name] = nil

      expect {
        patch order_path(order), params: order_data
      }.wont_change('Order.count')

      must_respond_with :bad_request
      expect(order.name).must_be_nil

    end

    it 'renders bad request on update if missing email' do

      order.valid?.must_equal true
      order.save

      order_data[:order][:email] = nil

      expect {
        patch order_path(order), params: order_data
      }.wont_change('Order.count')

      must_respond_with :bad_request
      expect(order.email).must_be_nil

    end

    it 'renders bad request on update if missing address' do

      order.valid?.must_equal true
      order.save

      order_data[:order][:address] = nil

      expect {
        patch order_path(order), params: order_data
      }.wont_change('Order.count')

      must_respond_with :bad_request
      expect(order.address).must_be_nil

    end

    it 'renders bad request on update if missing zip' do

      order.valid?.must_equal true
      order.save

      order_data[:order][:zip] = nil

      expect {
        patch order_path(order), params: order_data
      }.wont_change('Order.count')

      must_respond_with :bad_request
      expect(order.zip).must_be_nil

    end

    it 'renders bad request on update if missing cvv' do

      order.valid?.must_equal true
      order.save

      order_data[:order][:cvv] = nil

      expect {
        patch order_path(order), params: order_data
      }.wont_change('Order.count')

      must_respond_with :bad_request
      expect(order.cvv).must_be_nil

    end

    it 'renders bad request on update if exp_year is before the current_year' do

      order.valid?.must_equal true
      order.save

      order_data[:order][:exp_year] = Date.today.year - 1

      expect {
        patch order_path(order), params: order_data
      }.wont_change('Order.count')

      must_respond_with :bad_request
      expect(order.exp_year).must_be_nil
      expect( flash[:messages] ).must_include :exp_year

    end

    it 'renders bad request on update if exp_year and exp_month correlate to an expired card' do

      order.valid?.must_equal true
      order.save

      order_data[:order][:exp_year] = Date.today.year
      order_data[:order][:exp_month] = Date.today.month - 1

      expect {
        patch order_path(order), params: order_data
      }.wont_change('Order.count')

      must_respond_with :bad_request
      expect(order.exp_year).must_be_nil
      expect(order.exp_month).must_be_nil
      expect( flash[:messages] ).must_include :exp_month

    end

    it 'raises an error if exp_year is nil' do

      order.valid?.must_equal true
      order.save

      order_data[:order][:exp_year] = nil

      expect {
        patch order_path(order), params: order_data
      }.must_raise ArgumentError 

    end

    it 'raises an error if exp_year is nil' do

      order.valid?.must_equal true
      order.save

      order_data[:order][:exp_month] = nil

      expect {
        patch order_path(order), params: order_data
      }.must_raise ArgumentError

    end

  end

end
