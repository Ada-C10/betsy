require "test_helper"

describe Category do
  describe "validations" do
    before do
      category = Category.first
      @category = Category.new(name: "test name")
    end

    it "can be created with all required fields" do
      result = @category.valid?
      result.must_equal true
    end

    it "is invalid without a name" do
      @category.name = nil
      result = @category.valid?
      result.must_equal false
    end

    it "is invalid with a duplicate name" do
      dup_category = Category.first
      @category.name = dup_category.name
      result = @category.valid?
      result.must_equal false
    end
  end

  describe "relationships" do
    before do
      @category = Category.new(name: 'test name')
    end

    it "connects products and product_ids" do
      product = Product.first
      @category.products << product
      @category.product_ids.must_include product.id
    end
  end

  describe 'self.category_list' do
    it "can return all categories" do

      result = Category.category_list
      puts result

      result.length.must_equal 4
    end
  end

end
