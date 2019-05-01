require "test_helper"

describe OrderStatus do
  let(:order_status) { OrderStatus.new }

  it "must be valid" do
    value(order_status).must_be :valid?
  end
end
