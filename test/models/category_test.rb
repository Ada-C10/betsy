require "test_helper"

describe Category do
  before do
    @c = categories(:dog)
  end

  describe 'relations' do
    it 'has some products' do

      expect( @c.products ).must_respond_to :each

      @c.products.each do |product|
        expect( product ).must_be_instance_of Product
      end
    end
  end

  describe 'validations' do
    it 'is valid with a unique name' do

      expect( @c ).must_be :valid?
    end
    it 'is invalid without a name' do

      @c.name = nil

      expect( @c ).wont_be :valid?
    end

    it 'is invalid with a duplicate name' do

      dup_category = Category.new(name: @c.name )

      expect( dup_category ).wont_be :valid?
    end
  end
end
