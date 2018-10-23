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

    it 'is valid on update with properly formatted and completed fields: name, email, address, zip, cvv, exp_month, exp_year, and cc_num' do
      order_test = Order.new(order_data[:order])

      order_test.must_be :valid?, "Order data was invalid. Engineer, please fix this test."
      # binding.pry

      get root_path
            must_respond_with :success

      # expect {
      #   put order_path(Order.first.id), params: order_data
      # }.wont_change('Order.count')

      # must_respond_with :redirect
      # must_redirect_to work_path(existing_id)
      #
      # work = Work.find_by(id: existing_id)
      # expect(work.title).must_equal work_data[:work][:title]
      # expect(work.category).must_equal work_data[:work][:category]


    end

    it 'is invalid on update if missing credit card information' do

    end

  end

end
