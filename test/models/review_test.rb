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

    end

    it 'can se the review via a review id' do
      
    end


  end
end
