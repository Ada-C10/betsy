require "test_helper"

describe Review do
  before do
    @r = reviews(:review_one)
  end
  describe 'relations' do
    it 'has a product' do
      expect ( @r.product ).must_be_instance_of Product
    end
  end

  describe 'validations' do
    it 'is valid when name and rating is present, and rating is int between 1 and 5' do

      expect( @r ).must_be :valid?

    end

    it 'is invalid when name is missing' do

      @r.name = nil
      expect ( @r ).wont_be :valid?
    end

    it 'is invalid when rating is missing' do
      @r.rating = nil
      expect ( @r ).wont_be :valid?
    end

    it 'is invalid when rating is not an int between 1 through 5' do
      invalid_rating = 0

      expect( Review::RATINGS.include?(invalid_rating)).must_equal false

      @r.rating = invalid_rating

      expect( @r ).wont_be :valid?
    end
  end
end
