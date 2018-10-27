require "test_helper"

describe ReviewsController do
  let(:one) { merchants(:one)}
  let (:two) {merchants(:two)}
  let(:plushie) { products(:plushie) }

  describe "new" do
    describe "logged in users" do
      it "get to a new review page" do
        login(one)
        get new_product_review_path(plushie.id)
        must_respond_with :success
      end

      it "can't get to a new review page for non-existent product" do
        login(one)
        plushie.destroy
        get new_product_review_path(plushie.id)
        must_respond_with :not_found
      end
    end

    describe "guest users" do
      it "can get to a new review page" do
        get new_product_review_path(plushie.id)
        must_respond_with :success
      end

      it "can't get to a new review page for non-existent product" do
        plushie.destroy
        get new_product_review_path(plushie.id)
        must_respond_with :not_found
      end
    end

  end

  describe "create" do
    let (:good_data) { {review: {rating: 5, product: plushie, description: 'luv it!!'} } }
    let (:bad_data) { {review: {rating: -5, product: plushie, description: 'hate it!! :( '} } }
    let (:bad_data2) { {review: {rating: 1, product: plushie, description: ''} } }

    describe "logged in users" do
      it "can submit review for products they don't sell" do
        login(two)
        expect{
          post product_reviews_path(plushie.id), params: good_data
        }.must_change('Review.count', +1)

        must_redirect_to product_path(plushie.id)

      end

      it "can't submit review with invalid rating" do
        login(two)
        expect{
          post product_reviews_path(plushie.id), params: bad_data
        }.wont_change('Review.count')
        must_respond_with :bad_request
      end

      it "can't submit review with invalid description" do
        login(two)
        expect{
          post product_reviews_path(plushie.id), params: bad_data2
        }.wont_change('Review.count')
        must_respond_with :bad_request
      end

      it "can't submit a review for products they sell" do
        login(one)

        expect{
          post product_reviews_path(plushie.id), params: good_data
        }.wont_change('Review.count')

        must_respond_with :redirect
        must_redirect_to dashboard_path


      end
    end

    describe "guest users" do
      it "guest users can submit review" do
        expect{
          post product_reviews_path(plushie.id), params: good_data
        }.must_change('Review.count', +1)

        must_redirect_to product_path(plushie.id)
      end

      it "can't submit review with invalid rating" do
        expect{
          post product_reviews_path(plushie.id), params: bad_data
        }.wont_change('Review.count')
        must_respond_with :bad_request
      end

      it "can't submit review with invalid description" do
        expect{
          post product_reviews_path(plushie.id), params: bad_data2
        }.wont_change('Review.count')
        must_respond_with :bad_request
      end
    end

  end
end
