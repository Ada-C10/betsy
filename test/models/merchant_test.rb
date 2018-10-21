require "test_helper"

describe Merchant do
  # pull from fixtures
  let(:merchant) { merchants(:fred) }

  it "must be valid" do
    expect(merchant).must_be :valid?
  end

  describe "validations" do
    it "requires a name" do
      #use let for merchant, make name invalid
      merchant = merchants(:fred)
      merchant.name = nil

      valid = merchant.save

      expect(valid).must_equal false
      expect(merchant.errors.messages).must_include :name
      expect(merchant.errors.messages[:name]).must_equal ["can't be blank"]
    end

    it "requires a unique name" do
      other_merchant = merchants(:kiki)
      other_merchant.name = merchant.name

      valid = other_merchant.valid?

      expect(valid).must_equal false
      expect(other_merchant.errors.messages).must_include :name
    end

    it "requires an email" do
      merchant = merchants(:kiki)
      merchant.email = nil

      valid = merchant.save

      expect(valid).must_equal false
      expect(merchant.errors.messages).must_include :email
      expect(merchant.errors.messages[:email]).must_equal ["can't be blank"]
    end

    it "requires a unique email" do
      other_merchant = merchants(:kiki)
      other_merchant.email = merchant.email

      valid = other_merchant.valid?

      expect(valid).must_equal false
      expect(other_merchant.errors.messages).must_include :email
    end
  end

  describe "Relationships" do
   it "has a list of products" do
    kiki = merchants(:kiki)
    kiki.must_respond_to :products
    kiki.products.each do |product|
      product.must_be_kind_of Product
    end
   end

   it "has a list of order items" do
    kiki = merchants(:kiki)
    kiki.must_respond_to :orderitems
    kiki.orderitems.each do |item|
      item.must_be_kind_of Orderitem
    end
   end
  end

  describe "Custom Methods" do
    it "should return an accurate calculation of total revenue" do
      expect(merchant.total_revenue).must_equal 62
    end
  end
end
