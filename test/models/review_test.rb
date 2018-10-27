require "test_helper"

describe Review do
  # VALIDATIONS
  describe 'validations' do
    let(:review_one) { reviews(:review_one)}

    it 'is not valid without a product' do

      review_one.product = nil

      expect(review_one).must_be :invalid?
    end

    it 'is valid with all fields present' do
      expect(review_one).must_be :valid?
    end

  end

  # RELATIONS
  describe 'relations' do
    let(:review_two) { reviews(:review_two)}

    it 'must relate to a product' do
      expect(review_two).must_respond_to :product
      expect(review_two.product).must_equal products(:steak)
    end

    it 'can set the review via a review instance' do
      thyme = products(:thyme)

      review = Review.new(rating: 5, description: "best thing ever", product_id: thyme.id)

      expect(review).must_be_kind_of Review
      expect(review.product).must_be_kind_of Product

    end

    it 'can set the review for the correct product' do

      thyme = products(:thyme)

      review = Review.new(rating: 5, description: "best thing ever", product_id: thyme.id)

      review.save

      expect(thyme.reviews.first.product_id).must_equal thyme.id
      expect(thyme.reviews.first.description).must_equal "best thing ever"

      expect(thyme.reviews.first.rating).must_equal 5

    end


  end
end
