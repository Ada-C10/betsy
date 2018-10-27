require "test_helper"

describe Product do
  describe 'relations' do
    it 'has many reviews' do
      product = Product.first
      product.reviews.each do |review|
        review.must_be_instance_of Review
      end
    end

    it 'has many order_items' do
      product = Product.first
      product.order_items.each do |order_item|
        order_item.must_be_instance_of OrderItem
      end
    end

    it 'has many categories' do
      product = Product.first
      product.categories.each do |category|
        category.must_be_instance_of Category
      end
    end

    it 'belongs to a Merchant' do
      plushie = products(:plushie)
      plushie.must_respond_to :merchant
      plushie.merchant.must_be_kind_of Merchant
      plushie.merchant.username.must_equal "griffiam"
      plushie.merchant.must_equal merchants(:one)
    end
  end

  describe 'currency' do
    it 'converts price to float' do
      products(:plushie).currency.must_equal 15.00
    end
  end

  describe 'change inventory method' do
    it 'changes inventory stock on a product' do
      products(:plushie).change_inventory(2)
      products(:plushie).inventory.must_equal 8
    end
  end


  describe 'validations' do
    before do
      @product = Product.new(
        name: 'test_product',
        price: 1005,
        inventory: 4
      )
    end

    it 'is valid when name is present and unique, price is present, and inventory is present and greater or equal to 0' do
      plushie = products(:plushie)
      plushie.valid?.must_equal true
    end

    it 'is invalid without a name' do
      @product.name = nil
      is_valid = @product.valid?
      expect( is_valid ).must_equal false
      expect( @product.errors.messages ).must_include :name
    end

    it 'is invalid without a price' do
      @product.price = nil
      is_valid = @product.valid?
      expect( is_valid ).must_equal false
      expect( @product.errors.messages ).must_include :price
    end

    it 'is invalid if price is less or equal to 0' do
      @product.price = 0
      is_valid = @product.valid?
      expect( is_valid ).must_equal false
      expect( @product.errors.messages ).must_include :price

      @product.price = -2
      is_valid = @product.valid?
      expect( is_valid ).must_equal false
      expect( @product.errors.messages ).must_include :price
    end

    it 'is invalid without an inventory amt' do
      @product.inventory = nil
      is_valid = @product.valid?
      expect( is_valid ).must_equal false
      expect( @product.errors.messages ).must_include :inventory
    end

    it 'is invalid if inventory amt is less than 0' do
      @product.inventory = -1
      is_valid = @product.valid?
      expect( is_valid ).must_equal false
      expect( @product.errors.messages ).must_include :inventory
    end

    it 'is invalid with a non-unique name' do
      @product.name = Product.first.name
      is_valid = @product.valid?
      expect( is_valid ).must_equal false
      expect( @product.errors.messages ).must_include :name
    end
  end
end
