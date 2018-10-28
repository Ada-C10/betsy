require "test_helper"
describe Review do
  describe "relationships" do
    before do
      @review = reviews(:one)
      @lamb = products(:lamb)
    end

    it "belongs to a product" do
      @review.must_respond_to :product
      @review.product.must_be_kind_of Product
    end

    it "has a product id" do
      @review.product_id.must_equal @lamb.id
    end
  end

  describe "validations" do
    before do
      @review = reviews(:one)
      @goat = products(:goat)
    end

    it "requires a rating" do
      review = Review.new(name: "Wendy", review: "Wonderful goat.", product_id: @goat.id)
      review.valid?.must_equal false
    end

    it "requires a rating between 1 and 5" do
      review = Review.new(name: "Wendy", rating: 100, review: "Wonderful goat.", product_id: @goat.id)
      review.valid?.must_equal false
    end

    it "it's rating is a number" do
      review = Review.new(name: "Wendy", rating: "hello", review: "Wonderful goat.", product_id: @goat.id)
      review.valid?.must_equal false
    end

    it "requires a name" do
      review = Review.new(rating: 3, review: "Wonderful goat.", product_id: @goat.id)
      review.valid?.must_equal false
    end

    it "requires a review" do
      review = Review.new(name: "Wendy", rating: 3, product_id: @goat.id)
      review.valid?.must_equal false
    end
  end

end
