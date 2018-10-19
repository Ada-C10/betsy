require "test_helper"

describe Review do
  let(:review) { products(:kilreview) }

  it "must be valid" do
    expect(review).must_be :valid?
  end
end

describe "validations" do
  it "requires a rating" do
    review = reviews(:kilreview)
    review.rating = nil

    valid = review.save

    expect(valid).must_equal false
    expect(review.errors.messages).must_include :rating
    expect(review.errors.messages[:rating]).must_equal ["Cannot be blank"]
  end

  it "requires a description" do
    new_review = reviews(:kilreview)
    new_review.rating = nil

    valid = new_review.save

    expect(valid).must_equal false
    expect(review.errors.messages).must_include :description
    expect(review.errors.messages[:description]).must_equal ["Cannot be blank"]
  end
