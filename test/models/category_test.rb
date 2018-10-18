require "test_helper"

describe Category do
  let(:category) { Category.new }

  it "must be valid" do
    value(category).must_be :valid?
  end
end

describe "validations" do
  it "requires a name" do
    category = Catagory.new
    category.valid?.must_equal false
    category.errors.messages.must_include :name
  end
end
