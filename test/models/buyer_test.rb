require "test_helper"

describe Buyer do
  let(:buyer) { Buyer.new }

  it "must be valid" do
    value(buyer).must_be :valid?
  end
end
