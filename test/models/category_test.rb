require "test_helper"

describe Category do
  let(:category) { Category.first }

  # this was just to test that table data was valid
  it "must be valid" do
    skip
    Category.all.each do |c|
      expect(c.valid?).must_equal true
    end
  end

  # this was just to test that the has-many-and-belongs relationship works
  it "can access products through join table relations" do
    skip
    expect(category.products).must_respond_to :each

    category.products.each do |p|
      expect(p).must_be_instance_of Product
    end

  end
end
