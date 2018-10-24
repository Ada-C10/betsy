require "test_helper"

describe ReviewsController do
  let(:product){ products(:kilimanjaro) }
  let(:review_hash) do
    {
      review: {
        name: "Ciara",
        description: "Wonderful product!",
        product_id: product.id,
        rating: 4
      }
    }
  end

  describe "create" do
    it "creates a review given valid data" do
      expect {
        post reviews_path, params: review_hash
      }.must_change 'Review.count', 1

      review = Review.find_by(name: "Ciara")
      expect(flash[:status]).must_equal :success
      expect(flash[:result_text]).must_equal "Successfully created your review!"

      must_respond_with :redirect
      must_redirect_to product_path(review.product_id)
    end

    it "render bad_request and does not update the DB for invalid data" do
      review_hash[:review][:name] = nil

      expect {
        post reviews_path, params: review_hash
      }.wont_change 'Review.count'

      expect(flash[:status]).must_equal :failure
      expect(flash[:result_text]).must_equal "Could not create your review."

      must_respond_with :redirect
    end
  end
end
