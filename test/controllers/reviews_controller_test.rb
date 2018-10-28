require "test_helper"

describe ReviewsController do
  describe "new" do

    before do
      @goat = products(:goat)
    end

    it "succeeds" do
      get new_product_review_path(@goat .id)
      must_respond_with :success
    end
  end

  describe "create" do
    before do
      @goat = products(:goat)
    end

    it "creates a review with valid data" do
      review_hash = {
        review: {
          name: "Jane",
          rating: 5,
          review: "Best goat ever!",
          product_id: @goat.id
        }
      }

      expect {
        post product_reviews_path(@goat.id), params: review_hash
      }.must_change 'Review.count', 1

      must_respond_with  :redirect
      assert_equal 'Thanks for leaving a review!', flash[:success]

      expect(Review.last.name).must_equal review_hash[:review][:name]
      expect(Review.last.rating).must_equal review_hash[:review][:rating]
      expect(Review.last.review).must_equal review_hash[:review][:review]
    end

    it "fails to create a review with invalid data" do
      review_hash = {
        review: {
          name: "Jane",
          rating: "Hello",
          review: "Best goat ever!",
          product_id: "cheese"
        }
      }

      expect {
        post product_reviews_path(@goat.id), params: review_hash
      }.wont_change 'Review.count'

      must_respond_with  :redirect
      assert_equal 'Review unsuccessful.', flash[:warning]
    end

    it "a seller can't leave a review for their own product" do
      user = users(:tan)
      perform_login(user)
      review_hash = {
        review: {
          name: "Tan",
          rating: 5,
          review: "Best goat ever!",
          product_id: @goat.id
        }
      }

      expect {
        post product_reviews_path(@goat.id), params: review_hash
      }.wont_change 'Review.count'

      must_respond_with  :redirect
      assert_equal "You cannot review your own creatures!", flash[:warning]
    end
  end
  
end
