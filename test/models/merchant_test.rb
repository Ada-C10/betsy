require "test_helper"

describe Merchant do

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

  describe "Custom Methods" do
    describe "items_by_status" do
      it "if arg is 'all', returns a collection of orderitems as a hash" do
      # expect(merchant.total_revenue).must_equal 62
      end

      it "if arg is valid status, returns a collection of orderitems as an array" do
      # expect(merchant.total_revenue).must_equal 62
      end

      it "if merchant has no items of that status" do
        #expect empty collection
      end

    end

    describe "self.items_by_orderid(items)" do
      it "returns items as a hash grouped by orderid" do
      # loop in items, check that order id is all different
        # loop in items.first, check that order is is all same
        # check that all items in every array belong to the merchant
      {1=> [], 2=> []}
      end

      it "if arg is empty collection, it returns empty collection" do
        params = []
        expect .empty? == true
      end
    end

    describe "total_revenue" do
      it "should return an accurate calculation of total revenue" do
      # expect(merchant.total_revenue).must_equal 62
      end

      it "if there are no items of given status, it returns 0" do

      end
    end

    describe "revenue_by_status" do
      it "should return a hash with status keys and total revenue of all items" do
      # expect(merchant.total_revenue).must_equal 62
      end

      it "if there are no items of given status, it returns 0" do

      end
    end

  end
