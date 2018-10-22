require "test_helper"
describe Product do
  let(:kilimanjaro) { products(:kilimanjaro) }
  let (:fannypack) {products(:fannypack)}
  let (:safari) {products(:safari)}
  it "must be valid" do
    expect(kilimanjaro).must_be :valid?
  end

  describe "validations" do
    it "requires a name" do
      kilimanjaro.name = nil
      valid = kilimanjaro.save
      expect(valid).must_equal false
      expect(kilimanjaro.errors.messages).must_include :name
      expect(kilimanjaro.errors.messages[:name]).must_equal ["can't be blank"]
    end

    it "requires a unique name" do
      kilimanjaro.name = fannypack.name
      valid = kilimanjaro.valid?
      expect(valid).must_equal false
      expect(kilimanjaro.errors.messages).must_include :name
    end


    it "requires a cost greater than zero" do
      kilimanjaro.cost = 0
      valid = kilimanjaro.valid?
      expect(valid).must_equal false
      expect(kilimanjaro.errors.messages).must_include :cost
    end

    it "cost must be an integer" do
      fannypack.cost = "string"
      valid = fannypack.save
      expect(valid).must_equal false
      expect(fannypack.errors.messages).must_include :cost
    end

    it "cost must accept a value of nil" do
      kilimanjaro.cost = nil
      valid = kilimanjaro.save
      expect(valid).must_equal true
    end

    it "requires a inventory" do
      fannypack.inventory = nil
      valid = fannypack.save
      expect(valid).must_equal false
      expect(fannypack.errors.messages).must_include :inventory

    end

    it "inventory must be an integer" do
      fannypack.inventory = 1.5
      kilimanjaro.inventory = "string"

      fannypack.valid?.must_equal false
      kilimanjaro.valid?.must_equal false

      expect(kilimanjaro.errors.messages).must_include :inventory
      expect(fannypack.errors.messages).must_include :inventory
    end

    it "requires a description" do
      fannypack.description = nil
      fannypack.valid?.must_equal false
      expect(fannypack.errors.messages).must_include :description
    end

      it "active status can only be true or false" do
        safari.active = true
        fannypack.active = false
        kilimanjaro.active = nil
        safari.valid?.must_equal true
        fannypack.valid?.must_equal true
        kilimanjaro.valid?.must_equal false
        expect(kilimanjaro.errors.messages).must_include :active
      end

      it "requires a image" do
        fannypack.image_url = nil
        fannypack.valid?.must_equal false
        expect(fannypack.errors.messages).must_include :image_url
      end


    describe "custom methods" do
      it "adjust_inventory" do
        item = orderitems(:itemsone)

        order_items = []
        order_items << item

        product = Product.find_by(id: item.product.id)
        start_inventory = product.inventory

        Product.adjust_inventory(order_items)

        product = Product.find_by(id: item.product.id)
        end_inventory = product.inventory

        expect(start_inventory - end_inventory).must_equal item.quantity
      end
    end

    describe "relations" do
      it "has a list of reviews" do
        fannypack = products(:fannypack)
        fannypack.must_respond_to :reviews
        fannypack.reviews.each do |review|
          review.must_be_kind_of Review
        end
      end
      it "has a merchant" do
        fannypack = products(:fannypack)
        fannypack.must_respond_to :merchant
        fannypack.merchant.must_be_kind_of Merchant
      end
      it "has a list of order items" do
        fannypack = products(:fannypack)
        fannypack.must_respond_to :orderitems
        fannypack.orderitems.each do |item|
          item.must_be_kind_of Orderitem
        end
      end
      it "has a list of orders" do
        fannypack = products(:fannypack)
        fannypack.must_respond_to :orders
        fannypack.orders.each do |item|
          item.must_be_kind_of Order
        end
      end
      it "has a list of categories" do
        fannypack = products(:fannypack)
        fannypack.must_respond_to :categories
        fannypack.categories.each do |category|
          category.must_be_kind_of Category
        end
      end
    end
  end
end
