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
end
