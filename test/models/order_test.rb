require "test_helper"

describe Order do
  let(:pending_order) { orders(:pending_order) }

  it "must be valid" do
    value(pending_order).must_be :valid?
  end

  it 'has required fields' do
    fields = [:status, :user_id, :order_products, :products]

    fields.each do |field|
      expect(pending_order).must_respond_to field
    end
  end

  describe "relationships" do
    it "belongs to a user" do
      # Arrange is done with let

      # Act
      user = pending_order.user

      # Assert
      expect(pending_order).must_be_instance_of Order
      expect(user).must_be_instance_of User
    end

    it "can have many order products" do
      # Arrange is done with let

      # Act
      ops = pending_order.order_products

      # Assert
      expect(pending_order).must_be_instance_of Order

      expect(ops.length).must_be :>=, 1
      ops.each do |op|
        expect(op).must_be_instance_of OrderProduct
      end
    end

    it "can have 0 order products when status is pending" do
      # Arrange
      pending_order.order_products.each do |op|
        op.destroy
      end

      # Act
      order = Order.find_by(id: pending_order.id)
      ops = order.order_products

      # Assert
      expect(order.status).must_equal "pending"
      expect(ops.length).must_equal 0
    end

    it "can have many products through orderproducts" do
      # Arrange is done with let

      # Act
      products_in_order = pending_order.products

      # Assert
      expect(products_in_order.length).must_be :>=, 1
      products_in_order.each do |product|
        expect(product).must_be_instance_of Product
      end
    end

    it "can have 0 products through orderproducts when status is pending" do
      # Arrange
      pending_order.order_products.each do |op|
        op.destroy
      end

      # Act
      products_in_order = pending_order.products

      # Assert
      expect(pending_order.status).must_equal "pending"
      expect(products_in_order.length).must_equal 0
    end
  end

  describe "validations" do
    it "must have a user" do
      # Arrange
      pending_order.user = nil

      # Act
      valid = pending_order.valid?

      # Assert
      expect(valid).must_equal false
      expect(pending_order.errors.messages).must_include :user
      expect(pending_order.errors.messages[:user]).must_include "can't be blank", "must exist"

      # Rearrange
      pending_order.user = users(:user1)

      # Re-Act
      valid = pending_order.valid?

      # Reassert
      expect(valid).must_equal true
    end

    it "must have a status" do
      # Arrange
      pending_order.status = nil

      # Act
      valid = pending_order.valid?

      # Assert
      expect(valid).must_equal false
      expect(pending_order.errors.messages).must_include :status
      expect(pending_order.errors.messages[:status]).must_include "can't be blank", "must exist"

      # Rearrange
      pending_order.status = "pending"

      # Re-Act
      valid = pending_order.valid?

      # Reassert
      expect(valid).must_equal true
    end

    it "must have a status equal to pending, paid, or shipped" do
      # Arrange
      pending_order.status = "test"

      # Act
      valid = pending_order.valid?

      # Assert
      expect(valid).must_equal false
      expect(pending_order.errors.messages).must_include :status
      expect(pending_order.errors.messages[:status]).must_include "test is not a valid order status"

      # Rearrange
      pending_order.status = "pending"

      # Re-Act
      valid = pending_order.valid?

      # Reassert
      expect(valid).must_equal true

      # Rearrange
      pending_order.status = "paid"

      # Re-Act
      valid = pending_order.valid?

      # Reassert
      expect(valid).must_equal true

      # Rearrange
      pending_order.status = "shipped"

      # Re-Act
      valid = pending_order.valid?

      # Reassert
      expect(valid).must_equal true
    end
  end

  describe "total" do
    it "returns the sum of all of the order's order product subtotals" do
      # Arrange done with let

      # Act
      result = pending_order.total
      subtotals = pending_order.order_products.map { |op| op.subtotal }

      # Assert
      expect(result).must_equal subtotals.sum
    end

    it "returns a float" do
      # Arrange done with let

      # Act
      result = pending_order.total

      # Assert
      expect(result).must_be_instance_of Float
    end
  end

  describe "add_product" do
    let (:new_product) {
      Product.new(
        user: merchants(:merchant),
        name: "pants",
        price: 3,
        description: "a nice pair of pants",
        stock: 10,
        photo_url: "photo"
      )
    }

    it "adds a new order product with the designated quantity and pending status to the order if product not in cart" do
      # Arrange done with let

      # Act - Assert
      expect {
        pending_order.add_product(new_product, 2)
      }.must_change 'pending_order.order_products.length', 1

      expect(pending_order.order_products.last).must_be_instance_of OrderProduct
      expect(pending_order.order_products.last.quantity).must_equal 2
      expect(pending_order.order_products.last.status).must_equal "pending"
    end

    it "updates the existing order product quantity if the product is already in the cart" do
      # Arrange done with let and fixtures

      # Before addition
      expect(order_products(:dresses).quantity).must_equal 2

      expect {
        pending_order.add_product(products(:dress), 3)
      }.wont_change 'pending_order.order_products.length'

      # After addition
      op = OrderProduct.find_by(id: order_products(:dresses).id)
      expect(op.quantity).must_equal 3
    end

    it "will return true if successful" do
      # Arrange
      new_product.save

      # Act - Assert
      expect(pending_order.add_product(products(:dress), 2)).must_equal true
      expect(pending_order.add_product(new_product, 2)).must_equal true
    end

    it "will return false if requested quantity exceeds stock" do
      # Arrange done with let and before

      # Act - Assert
      expect(pending_order.add_product(products(:dress), 20)).must_equal false
      expect(pending_order.add_product(new_product, 20)).must_equal false
    end

    it "will return false if requested quantity is less than 1 or a non-integer" do
      # Arrange done with let and before

      # Act - Assert
      expect(pending_order.add_product(products(:dress), 0)).must_equal false
      expect(pending_order.add_product(new_product, -2)).must_equal false
      expect(pending_order.add_product(new_product, 1.5)).must_equal false
    end
  end

  describe "edit_quantity" do
    let (:dresses) { order_products(:dresses) }

    it "updates the quantity to the designated value" do
      # Arrange done with let

      # Act
      pending_order.edit_quantity(dresses, 3)

      # Assert
      expect(dresses.quantity).must_equal 3
    end

    it "cannot update the quantity to a value less than 1 or a non-integer" do
      # Arrange done with let

      # Act - Assert
      expect{
        pending_order.edit_quantity(dresses, 0)
      }.wont_change 'dresses.quantity'

      expect{
        pending_order.edit_quantity(dresses, -1)
      }.wont_change 'dresses.quantity'

      expect{
        pending_order.edit_quantity(dresses, 2.5)
      }.wont_change 'dresses.quantity'
    end

    it "must return true when successful" do
      # Arrange done with let

      # Act - Assert
      expect(pending_order.edit_quantity(dresses, 3)).must_equal true
    end

    it "must return false when unsuccessful" do
      # Arrange done with let

      # Act - Assert
      expect(pending_order.edit_quantity(dresses, -2)).must_equal false
    end

    it "cannot increase the quantity beyond the available stock" do
      # Arrange done with let

      # Act - Assert
      expect{
        pending_order.edit_quantity(dresses, products(:dress).stock + 1)
      }.wont_change 'dresses.quantity'

      expect(pending_order.edit_quantity(dresses, products(:dress).stock + 1)).must_equal false
    end
  end

  describe "submit_order" do
    it "updates the order status from pending to paid" do
      # Arrange done with let

      # Act - Assert
      expect(pending_order.status).must_equal "pending"
      pending_order.submit_order

      expect(pending_order.status).must_equal "paid"
    end

    it "updates the order's order products' statuses from pending to paid" do
      # Arrange done with let

      # Act - Assert
      pending_order.order_products.each do |op|
        expect(op.status).must_equal "pending"
      end

      pending_order.submit_order

      pending_order.order_products.each do |op|
        expect(op.status).must_equal "paid"
      end
    end

    it "updates the stock of the product on order" do
      # Arrange
      change = -(order_products(:dresses).quantity)

      # Act - Assert
      expect{
        pending_order.submit_order
      }.must_change 'Product.find_by(id: order_products(:dresses).product.id).stock', change
    end

    it "returns false if order submission fails" do
      # Arrange
      pending_order.user = nil

      # Act - Assert
      expect(pending_order.submit_order).must_equal false
    end

    it "returns true if order submission succeeds" do
      # Arrange done with let

      # Act - Assert
      expect(pending_order.submit_order).must_equal true
    end
  end
end
