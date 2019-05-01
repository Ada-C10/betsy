class Order < ApplicationRecord
  #validations
  validates :cust_name, presence: true, format: { with: /[a-zA-Z]/ }, on: :update
  validates :cc_digit, presence: true, format: { with: /\b\d{4}[ -]?\d{4}[ -]?\d{4}[ -]?\d{4}\b/, maxlength: 16 }, on: :update
  validates :cc_expiration, presence: true, on: :update
  validates :cc_cvv, presence: true, format: { with: /[0-9]{3}/ }, on: :update
  validates :cc_zip, presence: true, format: { with: /[0-9]{5}/ }, on: :update
  validates :cust_email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, on: :update
  validates :mailing_address, presence: true, on: :update
  #relationships
  has_many :order_items


  def items_in_cart
    num_in_cart = 0
    if self.order_items.empty?
      return 0
    else
      self.order_items.each do |item|
        if item.qty != nil
          num_in_cart += item.qty
        end
      end
    end
    return num_in_cart
  end

  def total_price
    self.order_items.sum do |order_item|
      product_id = Product.find_by(id: order_item.product_id)
      order_item.qty * product_id.price
    end
  end

  def place_order
    #decrease inventory
    self.order_items.each do |order_item|
      product = order_item.product
      # get quantity
      quantity = product.inv_qty
      # substract amount defined in order
      new_inv_qty = quantity - order_item.qty
      product.inv_qty = new_inv_qty
      product.update(inv_qty: new_inv_qty)
      if product.inv_qty <= 0
        product.update(active:false)
      end
      product.save!
    end
    self.update(status: "Paid")
  end


  def date_of_order
    return self.created_at.strftime("%B %d, %Y")
  end

  def check_order_status
    @order = self

    all_shipped = true
    @order.order_items.each do |item|
      if !item.shipped
        all_shipped = false
      end
    end

    if all_shipped
      @order.status = "Complete"
      @order.save
    end


  end

  def destroy
    # method to cancel order
  end

  private

    # def set_order_status
    #   self.order_status_id = 1
    # end


end
