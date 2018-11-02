require "test_helper"

describe OrderProduct do
  let(:shirts) { order_products(:shirts) }
  let(:dresses) { order_products(:dresses) }
  let(:dress) { products(:dress) }

  it "must be valid" do
    value(shirts).must_be :valid?
  end

  it 'has required fields' do
    fields = [:quantity, :order, :product, :status]

    fields.each do |field|
      expect(shirts).must_respond_to field
    end
  end

  describe "relationships" do
    it "must belong to an order" do
      # Arrange is done with let

      # Act
      order = shirts.order

      # Assert
      expect(order).must_be_instance_of Order
    end

    it "must belong to a product" do
      # Arrange is done with let

      # Act
      product = shirts.product

      # Assert
      expect(product).must_be_instance_of Product
    end
  end

  describe "validations" do
    it "must have a quantity" do
      # Arrange
      shirts.quantity = nil

      # Act
      valid = shirts.valid?

      # Assert
      expect(valid).must_equal false
      expect(shirts.errors.messages).must_include :quantity
      expect(shirts.errors.messages[:quantity]).must_include "can't be blank", "is not a number"

      # Rearrange
      shirts.quantity = 2

      # Re-Act
      valid = shirts.valid?

      # Reassert
      expect(valid).must_equal true
    end

    it "must have an integer quantity greater than 0" do
      # Arrange done with let

      # Act
      qt = shirts.quantity

      # Assert
      expect(qt).must_be_instance_of Integer
      expect(qt).must_be :>, 0
    end

    it "must have an order" do
      # Arrange
      shirts.order = nil

      # Act
      valid = shirts.valid?

      # Assert
      expect(valid).must_equal false
      expect(shirts.errors.messages).must_include :order
      expect(shirts.errors.messages[:order]).must_include "can't be blank", "must exist"

      # Rearrange
      shirts.order = orders(:pending_order)

      # Re-Act
      valid = shirts.valid?

      # Reassert
      expect(valid).must_equal true
    end

    it "must have a product" do
      # Arrange
      shirts.product = nil

      # Act
      valid = shirts.valid?

      # Assert
      expect(valid).must_equal false
      expect(shirts.errors.messages).must_include :product
      expect(shirts.errors.messages[:product]).must_include "can't be blank", "must exist"

      # Rearrange
      shirts.product = products(:shirt)

      # Re-Act
      valid = shirts.valid?

      # Reassert
      expect(valid).must_equal true
    end

    it "must have a status" do
      # Arrange
      dresses.status = nil

      # Act
      valid = dresses.valid?

      # Assert
      expect(valid).must_equal false
      expect(dresses.errors.messages).must_include :status
      expect(dresses.errors.messages[:status]).must_include "can't be blank", "must exist"

      # Rearrange
      dresses.status = "pending"

      # Re-Act
      valid = dresses.valid?

      # Reassert
      expect(valid).must_equal true
    end

    it "must have a status equal to pending, paid, shipped, or cancelled" do
      # Arrange
      dresses.status = "test"

      # Act
      valid = dresses.valid?

      # Assert
      expect(valid).must_equal false
      expect(dresses.errors.messages).must_include :status
      expect(dresses.errors.messages[:status]).must_include "test is not a valid order status"

      # Rearrange
      dresses.status = "pending"

      # Re-Act
      valid = dresses.valid?

      # Reassert
      expect(valid).must_equal true

      # Rearrange
      dresses.status = "paid"

      # Re-Act
      valid = dresses.valid?

      # Reassert
      expect(valid).must_equal true

      # Rearrange
      dresses.status = "shipped"

      # Re-Act
      valid = dresses.valid?

      # Reassert
      expect(valid).must_equal true

      # Rearrange
      dresses.status = "cancelled"

      # Re-Act
      valid = dresses.valid?

      # Reassert
      expect(valid).must_equal true
    end
  end

  describe "subtotal" do
    it "must return a float" do
      # Arrange done with let

      # Act
      result = dresses.subtotal

      # Assert
      expect(result).must_be_instance_of Float
    end

    it "must return the cost of the product times its quantity" do
      # Arrange done with let

      # Act
      result = dresses.subtotal

      # Assert
      expect(result).must_equal dresses.quantity * dress.price
    end
  end

  describe "edit_quantity" do
    it "updates the quantity to the designated value" do
      # Arrange done with let

      # Act
      dresses.edit_quantity(1)

      # Assert
      expect(dresses.quantity).must_equal 1
    end

    it "cannot update the quantity to a negative or non-integer value" do
      # Arrange done with let

      # Act - Assert
      expect{
        dresses.edit_quantity(-1)
      }.wont_change 'dresses.quantity'

      expect{
        dresses.edit_quantity(2.5)
      }.wont_change 'dresses.quantity'
    end

    it "destroys the order product if quantity selected is 0" do
      # Arrange
      id = dresses.id

      # Act
      dresses.edit_quantity(0)

      # Assert
      expect(OrderProduct.find_by(id: id)).must_be_nil
    end

    it "must return true when successful" do
      # Arrange done with let

      # Act - Assert
      expect(dresses.edit_quantity(3)).must_equal true
    end

    it "must return false when unsuccessful" do
      # Arrange done with let

      # Act - Assert
      expect(dresses.edit_quantity(-2)).must_equal false
    end

    it "cannot increase the quantity beyond the available stock" do
      # Arrange done with let

      # Act - Assert
      expect{
        dresses.edit_quantity(dress.stock + 1)
      }.wont_change 'dresses.quantity'

      expect(dresses.edit_quantity(dress.stock + 1)).must_equal false
    end
  end

  describe "submit_order" do
    it "reduces the stock by the quantity ordered" do
      expect{
        dresses.submit_order
      }.must_change 'dresses.product.stock', -2
    end

    it "returns true if successful" do
      expect(shirts.submit_order).must_equal true
    end

    it "returns false if unsuccessful" do
      # Arrange
      dresses.update(quantity: dresses.product.stock + 1)
      op = OrderProduct.find_by(id: dresses.id)

      # Act - Assert
      expect(op.submit_order).must_equal false
    end

    it "cannot reduce the stock below 0 or to a non-integer" do
      # Arrange done with let

      # Act - Assert
      expect{
        dresses.update(quantity: dresses.product.stock + 1)
        op = OrderProduct.find_by(id: dresses.id)
        op.submit_order
      }.wont_change 'dress.stock'

      expect{
        dresses.update(quantity: 1.5)
        op = OrderProduct.find_by(id: dresses.id)
        op.submit_order
      }.wont_change 'dress.stock'
    end

    it "updates the order product status from pending to paid" do
      # Arrange done with let

      # Act - Assert
      expect(dresses.status).must_equal "pending"

      dresses.submit_order

      expect(dresses.status).must_equal "paid"
    end
  end
end
