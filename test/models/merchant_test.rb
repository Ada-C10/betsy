require "test_helper"

describe Merchant do
  let(:merchant) { Merchant.first }

  # this was just to test that table data was valid
  it "must be valid" do
    skip
    Merchant.all.each do |m|
      expect(m.valid?).must_equal true
    end
  end


end
