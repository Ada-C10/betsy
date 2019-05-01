require "test_helper"

describe Product do
  let(:product)  { build(:product) }
  let(:product2) { create(:product)}

  describe "validation" do

    it "must be valid" do
      expect(product.valid?).must_equal true
    end

    it "must be invalid without a product name " do
      product.prod_name = nil

      expect(product.valid?).must_equal false
      expect(product.errors.messages).must_include :prod_name
    end

    it "must be invalid without a description" do
      product.description = nil

      expect(product.valid?).must_equal false
      expect(product.errors.messages).must_include :description
    end


    it "must be invalid without a price" do
      product.price = nil

      expect(product.valid?).must_equal false
      expect(product.errors.messages).must_include :price
    end


    it "must have a unique product name" do
      product.prod_name = product2.prod_name
      expect(product.valid?).must_equal false
    end


  end


  describe "relations" do

    # it "belong to a user" do
    #   expect(product.user).must_be_instance_of User
    #   expect(product.user.products).must_include product
    # end

    it "must respond to reviews" do
      expect(product).must_respond_to :reviews
    end

    it "responds to categories" do
      expect(product).must_respond_to :categories
    end

  end
end
