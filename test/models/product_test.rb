require "test_helper"
describe Product do
  let(:product) { products(:kilimanjaro) }

  # it "must be valid" do
  #   expect(product).must_be :valid?
  # end

  # describe "validations" do
  #   it "requires a name" do
  #     product.name = nil
  #
  #     valid = product.save
  #
  #     expect(valid).must_equal false
  #     expect(product.errors.messages).must_include :name
  #     expect(product.errors.messages[:name]).must_equal ["Cannot be blank"]
  #   end
  #
  #   it "requires a unique name" do
  #     other_product.name = product.name
  #
  #     valid = other_product.valid?
  #
  #     expect(valid).must_equal false
  #     expect(other_product.errors.messages).must_include :name
  #   end
  #
  #
  #   it "requires a cost" do
  #     product.cost = 3000.0
  #
  #     valid = product.save
  #
  #     expect(valid).must_equal true
  #   end
  #
  #   it "cost must be greater than zero" do
  #     product.cost = 3000.0
  #
  #     valid = product.save
  #
  #     expect(valid).must_equal :>=, 0
  #     expect(valid).must_be_instance_of Integer
  #   end
  #
  #   it "cost must accept a value of nil" do
  #     product.cost = nil
  #
  #     valid = product.save
  #
  #     expect(valid).must_equal true
  #   end
  #
  #
  #   it "requires a inventory" do
  #     product = products(:safari)
  #     product.inventory = nil
  #
  #     valid = product.save
  #
  #     expect(valid).must_equal false
  #     expect(product.errors.messages).must_include :inventory
  #     expect(product.errors.messages[:inventory]).must_equal ["Cannot be blank"]
  #   end
  #
  #   it "inventory must be an integer" do
  #     product.inventory = 10
  #
  #     valid = product.save
  #
  #     expect(valid).must_equal true
  #     expect(valid).must_be_instance_of Integer
  #   end
  #
  #   it "requires a description" do
  #     new_review.rating = nil
  #
  #     valid = new_review.save
  #
  #     expect(valid).must_equal false
  #     expect(review.errors.messages).must_include :description
  #     expect(review.errors.messages[:description]).must_equal ["Cannot be blank"]
  #   end
  #
  #   it "active status can only be true or false" do
  #     valid_statuses = ['true', 'false']
  #     valid_statuses.each do |status|
  #       product = Product.new(name: 'fanny pack', status: status)
  #       order.valid?.must_equal true
  #     end
  #   end
  #
  #   it "requires a image" do
  #   end
  # end

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
