require "test_helper"

describe Order do
  before do
    @pending = orders(:one)
    @pending.credit_card_exp_month = Date.today.month
    @pending.credit_card_exp_year = Date.today.year % 1000

    @empty = Order.new
  end

  describe 'relations' do
    it "has a list of order_items" do
      expect(@pending).must_respond_to :order_items
      @pending.order_items.each do |order_item|
        expect(order_item).must_be_kind_of OrderItem
      end
    end
  end

  describe 'validations' do
    it "will be a valid pending order even if credit card info is missing" do

      expect(@empty.status).must_equal "pending"
      expect(@empty.valid?).must_equal true
    end

    it 'will not save a valid order when updating without valid month' do

      @pending.update(credit_card_exp_month: 0)
      expect(@pending.valid?).must_equal false
    end

    it 'will not save a valid order when updating without valid years' do

      @pending.update(credit_card_exp_year: 0)
      expect(@pending.valid?).must_equal false
    end

    it 'will create a valid order with any order_items' do

      expect(@empty.order_items.length).must_equal 0
      expect(@empty.valid?).must_equal true
    end

    it 'will not update an order with any order_items' do
      expect(@empty.order_items.length).must_equal 0

      @empty.update(status: "paid")
      expect(@empty.valid?).must_equal false
    end

    it 'will update an order with one or more order_items' do
      expect(@pending.order_items.length).must_be :>=, 1
      @pending.update(status: "paid")
      expect(@pending.valid?).must_equal true
    end
  end

  describe 'submit_order' do
    it 'will change order and order items to pending' do
      expect(@pending.order_items.length).must_be :>=, 1
      expect(@pending.status).must_equal "pending"

      item_ids = @pending.order_items.map { |item| item.item_id }
      statuses = @pending.order_items.map {|item| item.status}.uniq
      expect(statuses.length).must_equal 1
      expect(statuses[0]).must_equal "pending"

      @pending.submit_order

      expect(@pending.status).must_equal "paid"
      new_statuses = @pending.order_items.map {|item| item.status}.uniq
      expect(new_statuses.length).must_equal 1
      expect(new_statuses[0]).must_equal "paid"

    end
  end

  describe 'self.valid_years' do
    it 'will an array of length 8 with years' do
      valid_years = Order.valid_years
      expect(valid_years.length).must_equal 9
    end
    it 'will include today\'s date until 8 years from today' do
      valid_years = Order.valid_years
      first = Date.today.year % 1000
      last = first + 8
      range = (first..last).to_a

      expect(valid_years).must_equal range
    end
  end

  describe 'self.valid_years' do
    it 'will an array of length 8 with years' do
      valid_years = Order.valid_years
      expect(valid_years.length).must_equal 9
    end
  end
end
