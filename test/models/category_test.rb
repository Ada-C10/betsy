require "test_helper"

describe Category do
  let(:category) { categories(:haunted) }

  it "must be valid" do
    expect(category).must_be :valid?
  end

  it 'has required fields' do
    field = :name

    expect(category).must_respond_to field
  end

  describe 'Validations' do
    it 'must have a category name' do
      category = categories(:zombie)
      category.name = nil

      valid = category.save

      expect(valid).must_equal false
      expect(category.errors.messages).must_include :name
    end
    it 'must have a unique category name' do
      other_category = categories(:zombie)
      other_category.name = category.name

      valid = other_category.save

      expect(valid).must_equal false
      expect(other_category.errors.messages).must_include :name
    end
  end

  describe 'Relationships' do
    it 'can have many products' do
      category.products << Product.first
      products = category.products

      #Assert
      expect(products.length).must_be :>=, 1
      products.each do |product|
        expect(product).must_be_instance_of Product
      end
    end
  end
end
