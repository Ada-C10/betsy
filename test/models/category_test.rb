require "test_helper"

describe Category do
  describe "relations" do

    it "has a list of products" do
      category = categories(:atlantis)
      category.must_respond_to :products
      category.products.each do |product|
        product.must_be_kind_of Product
      end
    end

    it "is included in a list of products" do
      category = categories(:atlantis)
      product = products(:thyme)
      category.must_respond_to :products
      product.categories.each do |category|
        category.must_be_kind_of Category
      end
    end
  end

  describe "validations" do
    it "requires a name" do
      category = Category.new
      category.valid?.must_equal false
      category.errors.messages.must_include :name
    end

    it "requires a unique name" do
      category1 = Category.new(name: "fake")
      category1.save!
      category2 = Category.new(name: "fake")

      category2.valid?.must_equal false
      category2.errors.messages.must_include :name
    end
  end
end

# has_and_belongs_to_many :products
#
# validates :name, uniqueness: true
