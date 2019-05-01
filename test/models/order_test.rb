require "test_helper"

describe Order do

    describe "items_in_cart" do

      it "returns the total quantity of items in cart" do
        order = orders(:one)
        number = order.items_in_cart

        expect(number).must_equal 4
      end

      it "returns 0 when no items in cart" do
        order = orders(:three)
        number = order.items_in_cart

        expect(number).must_equal 0
      end
    end

    describe "place order" do

      it "reduces inventory quantity by order item quantity" do
        order = orders(:one)
        inv_qty_before = order.order_items.first.product.inv_qty
        order_qty = order.order_items.first.qty

        order.place_order
        order = orders(:one)

        inv_qty_after = order.order_items.first.product.inv_qty
        expect(order.order_items.first.product.inv_qty).must_equal inv_qty_after
        expect(inv_qty_after).must_equal inv_qty_before - order_qty
      end
    end

    describe "total_price" do

      it "gets the correct total price when the order has items" do
        order = orders(:one)
        price_first_item = order.order_items.first.product.price * order.order_items.first.qty
        price_last_item = order.order_items.last.product.price * order.order_items.last.qty
        total_price = price_first_item + price_last_item

        order.total_price

        expect(order.total_price).must_equal total_price
      end
    end

describe "validation" do
  let(:user) { user(:one) }
  before do
    1.times do
      order = create(:order)
  describe "validation" do
    let(:order)  { build(:order) }

    it "must be valid with all parameters" do
      expect(order.valid?).must_equal true
    end

    it "must be invalid without a customer name " do
      order.cust_name = nil

      expect(order.valid?).must_equal false
      expect(order.errors.messages).must_include :cust_name
    end
  end

  # it "must be a valid order" do
  #
  #   expect(order.valid?).must_equal true
  # end

  it "must be invalid without a customer name " do
      expect(order.valid?).must_equal false
      expect(order.errors.messages).must_include :cust_email
    end

    order.cust_name = nil

    expect(order.cust_name.valid?).must_equal false
    expect(order.errors.messages).must_include :cust_name
  end

  it "must be invalid without an email address or correct data type " do
    order.cust_email = nil
    order.cust_email = 123
      expect(order.valid?).must_equal false
      expect(order.errors.messages).must_include :mailing_address
    end

    expect(order.cust_email.valid?).must_equal false
    expect(order.errors.messages).must_include :cust_email
  end


  it "must be invalid without a mailing address" do
    order.mailing_address = nil

    expect(order.mailing_address.valid?).must_equal false
    expect(order.errors.messages).must_include :mailing_address
  end


  it "must be invalid without a customer name" do
    order.cc_name = nil

    expect(order.cc_name.valid?).must_equal false
    expect(order.errors.messages).must_include :cc_name
  end

  # it "must be invalid if date has expired" do
  #   order.cc_expiration = 2018/08/21
  #
  #   expect(order.cc_name.valid?).must_equal false
  #   expect(order.errors.messages).must_include :cc_expiration
  # end

  it "must be invalid with more than 16 digits for credit card" do
    order.cc_digit = 123
    order2.cc_digit = "hi"

    expect(order.cc_digit.valid?).must_equal false
    expect(order2.cc_digit.valid?).must_equal false
    expect(order.errors.messages).must_include :cc_digit
    expect(order2.errors.messages).must_include :cc_digit
  end

  it "must have only 3 digits for CVV" do
    order.cc_cvv = 12
    order2.cc_cvv = "hi"

    expect(order.cc_cvv.valid?).must_equal false
    expect(order2.cc_cvv.valid?).must_equal false
    expect(order.errors.messages).must_include :cc_cvv
    expect(order2.errors.messages).must_include :cc_cvv
  end

  it "must be 5 digits in length for zip code" do
    order.cc_zip = 12
    order2.cc_zip = "hi"

    expect(order.cc_zip.valid?).must_equal false
    expect(order2.cc_zip.valid?).must_equal false
    expect(order.errors.messages).must_include :cc_zip
    expect(order2.errors.messages).must_include :cc_zip
  end
    it "must be invalid without a customer name" do
      order.cust_name = nil

      expect(order.valid?).must_equal false
      expect(order.errors.messages).must_include :cust_name
    end

    # it "must be invalid if date has expired" do
    #   order.cc_expiration = 2018/08/21
    #
    #   expect(order.cc_name.valid?).must_equal false
    #   expect(order.errors.messages).must_include :cc_expiration
    # end

    it "must be invalid with less than 16 digits for credit card" do
      order.cc_digit = 123

      expect(order.valid?).must_equal false
      expect(order.errors.messages).must_include :cc_digit

      order.cc_digit = "hi"

      expect(order.valid?).must_equal false
      expect(order.errors.messages).must_include :cc_digit
    end

    it "must have only 3 digits for CVV" do
      order.cc_cvv = 12

      expect(order.valid?).must_equal false
      expect(order.errors.messages).must_include :cc_cvv

      order.cc_cvv = "hi"

      expect(order.valid?).must_equal false
      expect(order.errors.messages).must_include :cc_cvv
    end

    it "must have only 16 digits for Credit Card number" do
      order.cc_digit = 1234123412341234

      expect(order.valid?).must_equal true
    end

    it "must be 5 digits in length for zip code" do
      order.cc_zip = 1255

      expect(order.valid?).must_equal false
      expect(order.errors.messages).must_include :cc_zip

      order.cc_zip = "hi"

      expect(order.valid?).must_equal false
      expect(order.errors.messages).must_include :cc_zip
    end


  # describe "relations" do
  #
  #   it "belong to a product" do
  #     expect(order.user).must_be_instance_of User
  #     expect(order.user.orders).must_include Order
  #   end
  # end

end
describe "relations" do

  it "belong to a product" do
    order = product.order
    #add the yml file
    expect(order).must_be_instance_of Product
    expect(order.id).must_equal product.order_id
  end
end

end
