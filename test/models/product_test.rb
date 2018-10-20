require "test_helper"

describe Product do
  let(:product) { Product.first }

  # this was just to test that table data was valid
  it "must be valid" do
    skip
    Product.all.each do |p|
      expect(p).must_be :valid?
    end
  end

  # this was just to test that the relations work
  it 'must have access to categories' do
    skip
    puts product.name
    puts product.categories.count
    product.categories.each do |c|
      puts c.name
    end

  end


end
