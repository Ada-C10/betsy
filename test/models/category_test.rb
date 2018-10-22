require "test_helper"

describe Category do
  let(:category) { categories(:bags) }

  it "must be valid" do
    expect(category).must_be :valid?
  end

  describe "validations" do

    it "requires a name" do
      category = categories(:bags)
      category.name = nil

      valid = category.save
      expect(valid).must_equal false
      expect(category.errors.messages).must_include :name
      expect(category.errors.messages[:name]).must_equal ["can't be blank"]
    end
  end

  describe "relationships" do
    it "has a list of products" do
      africa = categories(:africa)
      africa.must_respond_to :products
      africa.products.each do |product|
        product.must_be_kind_of Product
      end
    end
  end
end
