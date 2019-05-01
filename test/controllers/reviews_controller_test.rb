require "test_helper"

describe ReviewsController do
  let(:review) { reviews :one }

  it "gets index" do
    get reviews_url
    value(response).must_be :successful?
  end

  describe "new" do

    it "gets the form with the new review page" do
      id = products(:cake1).id

      get new_product_review_path(id)
      value(response).must_be :successful?
    end

  end

  describe "create" do

    it "creates a new review given valid params" do
      id = products(:cake1).id
      review_hash = { review: { description: review.description, rating: review.rating} }

      expect {
        post product_reviews_path(id), params: review_hash
      }.must_change "Review.count", 1

      must_redirect_to product_path(id)

      expect(Review.last.description).must_equal review_hash[:review][:description]
      expect(Review.last.rating).must_equal review_hash[:review][:rating]
    end

    it "respond with an redirect for invalid params" do
      id = products(:cake1).id
      review_hash = { review: { description: review.description } }

      expect {
        post product_reviews_path(id), params: review_hash
      }.wont_change "Review.count"

      must_respond_with :success
      expect(flash[:warning]).must_equal "Please enter all fields"
    end

    it "respond with an error if merchant reviews their own product" do
      user = users(:laura)
      perform_login(user)

      id = products(:cake1).id
      review_hash = { review: { description: review.description, rating: review.rating} }

      expect {
        post product_reviews_path(id), params: review_hash
      }.wont_change "Review.count"

      must_redirect_to products_path
      expect(flash[:warning]).must_equal "You can't review your own Product"
    end
  end


end
