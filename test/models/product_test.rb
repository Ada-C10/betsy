require "test_helper"
# has_many :reviews
# has_many :order_items
# belongs_to :merchant
# has_and_belongs_to_many :categories

# validates :name, presence: true, uniqueness: true
# # TODO: maybe product name must be unique to category???
# validates :price, presence: true, numericality: { greater_than: 0 }

describe Product do
  let(:product) { Product.new }
  let(:product1) { products(:poodr) }
  let(:product2) { products(:koolaid) }

  # before do
  #   @product = Product.new(name: 'test title', price: 20, description: 'test description', merchant: 'jupiter')
  # end

  it "must be valid" do
    expect(product.valid?).must_equal false
  end

  it 'must have a name' do
    expect(product1.valid?).must_equal true
    product1.name = ''
    expect(product1.valid?).must_equal false
  end

  it 'has a unique name' do
    product2.name = product1.name
    expect(product2.valid?).must_equal false
  end

  it 'has a valid price' do
    test_product = products(:koolaid)
    expect(test_product.price).must_equal 100
    expect(test_product.valid?).must_equal true

    ['', 'not a price', '1dollar'].each do |invalid|
      test_product.price = invalid
    end
    expect(test_product.valid?).must_equal false
  end

  it 'has a price greater than 0' do
    product1.price = -2
    expect(product1.valid?).must_equal false
  end

  it 'has valid stock' do
    test_product = products(:koolaid)
    ['', -1, 'cow'].each do |invalid|
      test_product.inventory = invalid
    end
    expect(product2.valid?).must_equal false
  end

  it 'can have 0 stock' do
    product2.inventory = 0
    expect(product2.valid?).must_equal true
  end
end
