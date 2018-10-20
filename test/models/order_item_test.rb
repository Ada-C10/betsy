require "test_helper"

describe OrderItem do
  let(:order_item) { OrderItem.first }

  # this was just to test that table data was valid
  it "must be valid" do
    skip
    OrderItem.all.each do |o|
      expect(o.valid?).must_equal true
    end
  end
end
