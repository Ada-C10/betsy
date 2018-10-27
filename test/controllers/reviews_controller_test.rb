require "test_helper"
require 'pry'

describe ReviewsController do

  describe "Logged in merchants" do

    before do
      bake_off = merchants(:bake_off)
      perform_login(merchants(:bake_off))
      @thyme = products(:thyme)

    end

    describe "create-ability for logged-in merchants" do

      let(:review_data) {
        {
          id: @thyme.id ,
          review: {
            rating: 5,
            description: "awesome",
          }
        }
      }

      it "can create a review for products that aren't their own" do


        expect{
          post create_review_path(@thyme.id), params: review_data
        }

        must_redirect_to root_path
        flash[:status].must_equal :success

      end

      it "cannot create a review for their own products" do
        steak = products(:steak)

        review_data[:id] = steak.id

        expect{
          post create_review_path(steak.id), params: review_data
        }

        must_redirect_to root_path
        flash[:status].must_equal :failure
      end

      it "cannot create a review for a product that doesn't exist" do
        review_data
        steak = products(:steak)
        steak.id = nil

        review_data[:id] = nil

        expect{
          post create_review_path(steak.id), params: review_data
        }

        # binding.pry

        must_redirect_to root_path
        flash[:status].must_equal :failure

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
