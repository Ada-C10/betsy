require "test_helper"

describe Orderitem do
  let(:orderitem) { orderitems(:itemsone) }

  it "must be valid" do
    expect(orderitem).must_be :valid?
  end

  # describe "validations" do
  #   it "requires a quantity" do
  #     order = orderitems(:itemsone)
  #     order.quantity = nil
  #
  #     valid = order.save
  #
  #     expect(valid).must_equal false
  #     expect(order.errors.messages).must_include :quantity
  #     expect(order.errors.messages[:quantity]).must_equal ["Cannot be blank"]
  #   end
  #
  #   it "requires quanity to be integers" do
  #     order_thing = Orderitem.new(quantity: 1)
  #
  #     valid = order_thing.save
  #
  #     valid.must_equal true
  #     valid.must_be_instance_of Integer
  #   end
  # end
  #
  # describe "line_item_price" do
  #   it "will return an accurate cost of an item with quantity" do
  #     item = orderitems(:itemsfour)
  #     cost = item.line_item_price
  #
  #     expect(cost).must_equal (101.0 * 4)
  #   end
  # end

  describe "relations" do
    it "has a list of merchants" do
      itemsone = orderitems(:itemsone)
      itemsone.must_respond_to :merchants
      itemsone.merchants.each do |merchant|
        merchant.must_be_kind_of Merchant
      end
    end
    it "has a order" do
      itemsone = orderitems(:itemsone)
      itemsone.must_respond_to :order
      itemsone.order.must_be_kind_of Order
    end
    it "has a product" do
      itemsone = orderitems(:itemsone)
      itemsone.must_respond_to :product
      itemsone.product.must_be_kind_of Product
    end
  end
end
