require "test_helper"

describe Category do

  describe 'validations' do
    before do
      @category = Category.new(name: 'candies')
    end

    it 'is valid when name is present and unique' do
      result = @category.valid?
      expect( result ).must_equal true
    end


    it 'is invalid without a name' do
      @category.name = nil

      result = @category.valid?

      expect( result ).wont_equal true
      expect( @category.errors.messages ).must_include :name
    end

    it 'is invalid with a non-unique name' do
      @category = Category.new(name: 'toy')
      result = @category.valid?

      expect( result ).wont_equal true
      expect( @category.errors.messages ).must_include :name
    end

  end
end
