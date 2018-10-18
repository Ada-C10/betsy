require "test_helper"
#Sammi Joo
describe Orderitem do
  let(:orderitem) { Orderitem.new }

  it "must be valid" do
    value(orderitem).must_be :valid?
  end
end

describe "validations" do
  it "requires a quantity" do
    merchant = Merchant.new
    merchant.valid?.must_equal false
    merchant.errors.messages.must_include :name
  end

  it "only allows quantity integers"
  end
end





  # validates :quantity, presence: true, numericality: { only_integer: true }
