require "test_helper"

describe Review do
  let(:review) { reviews(:kilreview) }

  it "must be valid" do
    expect(review.valid?).must_equal true
  end

  describe "Relationships" do
    it "has a product" do
      my_product = reviews(:fanreview)
      my_product.must_respond_to :product
      my_product.product.must_be_kind_of Product
    end
  end

  describe "Validations" do
    it "requires a name" do
      review.name = nil
      review.valid?.must_equal false
      expect(review.errors.messages).must_include :name
      expect(review.errors.messages[:name]).must_equal ["can't be blank"]
    end

    it "requires a rating" do
      review = reviews(:kilreview)
      review.rating = nil

      valid = review.save

      expect(valid).must_equal false
      expect(review.errors.messages).must_include :rating
      expect(review.errors.messages[:rating]).must_equal ["can't be blank", "is not a number"]
    end

    it "requires a description" do
      new_review = reviews(:kilreview)
      new_review.description = nil

      valid = new_review.save

      expect(valid).must_equal false
      expect(review.errors.messages).must_include :description
      expect(review.errors.messages[:description]).must_equal ["can't be blank"]
    end
  end
end
