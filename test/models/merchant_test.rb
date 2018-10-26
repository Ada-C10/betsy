require "test_helper"

describe Merchant do
  before do
    @m = merchants(:dogdays)
  end
  describe 'relations' do
    it 'has some products' do

      expect( @m.products ).must_respond_to :each

      @m.products.each do |product|

        expect( product ).must_be_instance_of Product
      end
    end
  end

  describe 'validations' do
    let (:new_merchant) {
      Merchant.new(
        username: 'testusername',
        email: 'testemail@ada.com',
        uid: 9999,
        provider: 'github'
      )
    }


    it 'is valid when username and email is unique and present' do

      expect( @m ).must_be :valid?

    end

    it 'is invalid without a username' do
      @m.username = nil

      expect ( @m ).wont_be :valid?
    end

    it 'is invalid when username is non unique' do

      expect( new_merchant ).must_be :valid?

      new_merchant.username = @m.username

      expect( new_merchant ).wont_be :valid?
    end

    it 'is invalid without an email' do
      @m.email = nil

      expect( @m ).wont_be :valid?
    end

    it 'is invalid when email is non unique' do
      expect( new_merchant).must_be :valid?

      new_merchant.email = @m.email

      expect( new_merchant ).wont_be :valid?
    end

  end

  describe 'rating' do
    it 'returns average of all product ratings' do
      expect( @m.rating ).must_be_close_to 4.17, 0.01
    end

    it 'returns nil if no products' do
      @m.products.each do |product|
        product.destroy
      end

      @m.reload

      expect( @m.rating ).must_be_nil
    end
  end
end
