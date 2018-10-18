require "test_helper"

describe Merchant do
  let(:merchant) { Merchant.new }

  it "must be valid" do
    value(merchant).must_be :valid?
  end
end

describe "validations" do
  it "requires a name" do
    merchant = Merchant.new
    category.valid?.must_equal false
    category.errors.messages.must_include :name
  end

  it "requires a unique name" do
    
end


# validates :name, presence: true, uniqueness: true
# validates :email, presence: true, uniqueness: true
