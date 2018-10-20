require "test_helper"

describe OrderItem do
  let(:order_item) { OrderItem.first }

  it "must be valid" do
    value(order_item).must_be :valid?
  end
end
