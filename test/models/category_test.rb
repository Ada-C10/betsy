require "test_helper"

describe Category do
  let(:category) { Category.new }

  it "must be valid" do
    value(category).must_be :valid?
  end

  describe 'validations' do
    it 'has required fields' do
      fields = [:category]

      fields.each do |field|
        expect(book).must_respond_to field
      end
    end
  end

  describe 'relationship' do
    let(:product) { products(:cake1) }
    it 'belongs to product' do
      cat = product.category

      expect(cat).must_be_instance_of Product
      expect(cat.id).must_equal product.category_id
    end
  end
end
