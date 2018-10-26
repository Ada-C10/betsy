require "test_helper"
require 'pry'

describe ReviewsController do

  describe "Logged in merchants" do

    before do
      bake_off = merchants(:bake_off)
      perform_login(merchants(:bake_off))
    end

    describe "create-ability for logged-in merchants" do
      it "can create a review for products that aren't their own" do

        review = reviews(:review_one)
        thyme = products(:thyme)
        post create_review_path(review)

        must_respond_with :success

      end

      it "cannot create a review for their own products" do
      end

      it "cannot create a review for a product that doesn't exist" do
      end
    end
  end

  describe "Guest users" do
    describe "Guest users can create a review" do

      it "guests can create a review for a product that exists" do
        review_data = {
          review: {
            rating: 5,
            description: "great",
            product_id: 3
          }
        }

        review = Review.new(review_data(:review))

        expect {
          post create_review_path(review)
        }.must_change('Review.count', +1)


        must_respond_with :success

      end

      it "guests cannot create a review for a product that doesn't exist" do

      end
    end
  end
end
