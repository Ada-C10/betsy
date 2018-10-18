require "test_helper"

describe Product do
  let(:product) { Product.new }

  it "must be valid" do
    value(product).must_be :valid?
  end
end

describe "validations" do
  it "requires a name" do
    product = Product.new
    product.valid?.must_equal false
    product.errors.messages.must_include :name
  end
end



# validates :name, presence: true, uniqueness: true
# validates :cost, presence: true, numericality: { greater_than: 0 }, allow_nil: true
# validates :inventory, presence: true, numericality: { only_integer: true }
# validates :description, presence: true
# validates :active, inclusion: { in: [true, false] }
# validates :image_url, presence: true
