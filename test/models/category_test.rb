require "test_helper"

describe Category do
  let(:category) { Category.first }

  it "must be valid" do
    expect(category.valid?).must_equal true
  end
end
