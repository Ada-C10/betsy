require "test_helper"

describe Review do
  let(:review) { Review.new(rating: "1", description: "this is great", product: Product.new) }

  it "must be valid" do
    expect(review.valid?).must_equal true
  end

  describe "relations" do

    it "must respond to product" do
      expect(review).must_respond_to :product
    end

  end

  describe "validations" do

    it "invalid without a rating" do
      review.rating = nil
      expect(review.valid?).must_equal false
      expect(review.errors.messages).must_include :rating
    end

  end
end
