require "test_helper"
require "pry"

describe Product do
  describe "relations" do
    it "has a list of categories" do
       product = products(:thyme)
       product.must_respond_to :categories
       product.categories.each do |category|
         category.must_be_kind_of Category
       end
    end

    it "has a list of order_items" do
      product = products(:thyme)
      product.must_respond_to :order_items
      product.order_items.each do |item|
        item.must_be_kind_of OrderItem
      end
    end

    it "is associated with a merchant" do
      product = products(:thyme)
      product.merchant.must_be_kind_of Merchant
    end
  end

  describe "validations" do
    it "requires a name" do
      product = Product.new(price: 1)
      product.valid?.must_equal false
      product.errors.messages.must_include :name
    end

    it "requires a price" do
      product = Product.new(name: "fake")
      product.valid?.must_equal false
      product.errors.messages.must_include :price
    end

    it "requires a unique name" do
      product1 = Product.new(name: "fake", merchant: merchants(:iron_chef), price: 1)
      product1.save!
      product2 = Product.new(name: "fake", merchant: merchants(:iron_chef), price: 1)

      product2.valid?.must_equal false
      product2.errors.messages.must_include :name
    end

    it "does not require a unique price" do
      product1 = Product.new(name: "fake", price: 1, merchant: merchants(:iron_chef))
      product1.save!
      product2 = Product.new(name: "faker", price: 1, merchant: merchants(:iron_chef))

      product2.valid?.must_equal true
    end
  end

end

# validates :name, presence: true, uniqueness: true
# validates :price, presence: true, numericality: {greater_than: 0}
