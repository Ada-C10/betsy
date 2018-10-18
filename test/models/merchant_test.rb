require "test_helper"

describe Merchant do
  describe 'relations' do
    it 'has many products' do
      merchant = Merchant.first
      merchant.products.each do |product|
        product.must_be_instance_of Product
      end
    end
  end

  describe 'validations' do
    before do
      @merchant = Merchant.new(
        username: 'test_merchant',
        email: 'test_merchant@braineaze.com'
      )
    end

    it 'is valid when username is present and unique and email is present and unique' do
      is_valid = @merchant.valid?
      expect( is_valid ).must_equal true
    end

    it 'is invalid without a username' do
      @merchant.username = nil
      is_valid = @merchant.valid?
      expect( is_valid ).must_equal false
      expect( @merchant.errors.messages ).must_include :username
    end

    it 'is invalid without a email' do
      @merchant.email = nil
      is_valid = @merchant.valid?
      expect( is_valid ).must_equal false
      expect( @merchant.errors.messages ).must_include :email
    end

    it 'is invalid with a non-unique username' do
      @merchant.username = Merchant.first.username
      is_valid = @merchant.valid?
      expect( is_valid ).must_equal false
      expect( @merchant.errors.messages ).must_include :username
    end

    it 'is invalid with a non-unique email' do
      @merchant.email = Merchant.first.email
      is_valid = @merchant.valid?
      expect( is_valid ).must_equal false
      expect( @merchant.errors.messages ).must_include :email
    end
  end
end
