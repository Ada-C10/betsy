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
        orderitems = merchant.items_by_status("all")

        orderitems.each do |key, value|
          expect(STATUSES).must_include key
          value.each do |item|
            expect(item).must_be_kind_of Orderitem
          end
        end

        expect(orderitems).must_be_kind_of Hash
       end
      end

      it "if arg is valid status, returns a collection of orderitems as an array" do
        orderitems = merchant.items_by_status("complete")

        expect(orderitems).must_be_kind_of Array
        orderitems.each do |item|
          expect(item).must_be_kind_of Orderitem
        end
      end

      it "if merchant has no items of that status" do
        orderitems = merchant.items_by_status("paid")

        expect(orderitems).must_be_kind_of Array
        expect(orderitems.length).must_equal 0
      end
    end

    describe "self.items_by_orderid(items)" do
      it "takes in an array of orderitems and returns items as a hash grouped by orderid" do
        item1 = orderitems(:itemsone)
        item2 = orderitems(:itemstwo)
        item3 = orderitems(:itemsthree)
        items = []
        items << item1
        items << item2
        items << item3
        order_ids = []

        orderitems = Merchant.items_by_orderid(items)
        orderitems.each do |key, value|
          order_ids << key
          value.each do |item|
            expect(item).must_be_kind_of Orderitem
          end
        end

        expect(order_ids.uniq.length).must_equal 3
      end

      it "if arg is empty collection, it returns empty collection" do
        items = []
        orderitems = Merchant.items_by_orderid(items)

        expect(orderitems.length).must_equal 0
        expect(orderitems).must_be_kind_of Array
      end
    end

    describe "total_revenue" do
      it "should return an accurate calculation of total revenue" do
        expect(merchant.total_revenue).must_equal (15.5 * 3)
      end

      it "if there are no paid or complete items, it returns 0" do
        item = orderitems(:itemsthree)
        item.destroy

        expect(merchant.total_revenue).must_equal 0
      end
    end

    describe "revenue_by_status" do
      it "should return a hash with status keys and total revenue of all items" do

        revenue_hash = merchant.revenue_by_status
        expect(revenue_hash).must_be_kind_of Hash

        keys = revenue_hash.keys
        keys.each do |key|
          expect(STATUSES).must_include key
        end

        values = revenue_hash.values

        values.each do |value|
          expect(value).must_be_kind_of Numeric
        end
      end

      it "if there are no items of given status, it returns 0" do
        merchant = merchants(:bob)

        revenue_hash = merchant.revenue_by_status

        expect(revenue_hash).must_be_kind_of Hash

        keys = revenue_hash.keys
        keys.each do |key|
          expect(STATUSES).must_include key
        end

        values = revenue_hash.values

        values.each do |value|
          expect(value).must_equal 0
        end
      end
    end
  end
end
