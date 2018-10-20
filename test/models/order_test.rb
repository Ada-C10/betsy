require "test_helper"

describe Order do
  let(:order) { Order.first }

  it "must be valid" do
    value(order).must_be :valid?
  end
end
