require "test_helper"

describe Product do

  before do
    @p = Product.first
  end

  describe 'relations' do

    it 'has a merchant' do

      expect( @p.merchant ).must_be_instance_of Merchant

    end
    it 'has some reviews' do

      expect( @p.reviews ).must_respond_to :each
      expect( @p.reviews.first ).must_be_instance_of Review

    end

    it 'has some order items' do

      expect( @p.order_items ).must_respond_to :each
      expect( @p.order_items.first ).must_be_instance_of OrderItem

    end

    it 'has some categories' do
      expect( @p.categories).must_respond_to :each
      expect( @p.categories.first ).must_be_instance_of Category
    end
  end

  describe 'validations' do
    it 'is valid when required fields are present and price and stock are valid inputs' do

      expect( @p ).must_be :valid?

    end

    it 'is invalid without a name' do

      @p.name = nil

      expect( @p ).wont_be :valid?
    end

    it 'is invalid without a price' do

      @p.price = nil

      expect( @p ).wont_be :valid?

    end

    it 'is invalid with a price less than or equal to zero' do

      @p.price = 0

      expect( @p ).wont_be :valid?

      @p.price = -1

      expect( @p ).wont_be :valid?
    end

    it 'is invalid without a stock' do

      @p.stock = nil

      expect( @p ).wont_be :valid?
    end

    it 'is invalid with a negative stock' do

      @p.stock = -1

      expect( @p ).wont_be :valid?

    end

  end

  describe 'rating' do
    it 'returns average of the reviews rating' do

      expect( @p.rating ).must_be_close_to 3.5, 0.01
    end

    it 'returns nil for a product with no reviews' do
      no_reviews = products(:product_two)

      expect( no_reviews.rating ).must_be_nil
    end
  end
end
