require "test_helper"

describe OrderItemsController do
  let(:plushie) {products(:plushie)}
  let(:plushie_merchant) {merchants(:one)}
  let(:not_plushie_merchant) {merchants(:two)}

  describe "Create" do
    it "it can create an Order Item (add item to cart) for a Guest user" do
      product = plushie
      qty_requested = product.inventory
      order_item_data = {
        order_item: {
          quantity: qty_requested,
          product_id: product.id
        }
      }
      expect {
        post order_items_path, params: order_item_data
      }.must_change('OrderItem.count', +1)

      OrderItem.last.quantity.must_equal qty_requested
      must_respond_with :redirect
      must_redirect_to cart_path
    end

    it "it can create an Order Item (add item to cart) for a Merchant that doesn't have the product" do
      login(not_plushie_merchant)
      product = plushie
      qty_requested = product.inventory
      order_item_data = {
        order_item: {
          quantity: qty_requested,
          product_id: product.id
        }
      }
      expect {
        post order_items_path, params: order_item_data
      }.must_change('OrderItem.count', +1)

      OrderItem.last.quantity.must_equal qty_requested
      must_respond_with :redirect
      must_redirect_to cart_path
    end

    it "renders 404 not_found for a bogus order_item data when trying to add to cart" do
      order = Order.first
      product = plushie

      order_item_data = {
        order_item: {
          quantity: 0,
          product_id: product.id
        }
      }

      expect {
        post order_items_path, params: order_item_data
      }.wont_change('OrderItem.count')

      must_redirect_to root_path
    end

    it "renders a bad request if the quantity requested is more than the product inventory" do
      order = Order.first
      product = plushie
      bad_qty = product.inventory + 1
      order_item_data = {
        order_item: {
          quantity: bad_qty,
          product_id: product.id
        }
      }

      expect {
        post order_items_path, params: order_item_data
      }.wont_change('OrderItem.count')
      must_redirect_to root_path
    end

    it "updates the qty requested if the order item is already in the cart for a Guest user" do
      product = plushie
      qty_requested = 7
      order_item_data = {
        order_item: {
          quantity: qty_requested,
          product_id: product.id
        }
      }

      post order_items_path, params: order_item_data

      expect {
        post order_items_path, params: order_item_data
      }.wont_change('OrderItem.count')

      OrderItem.last.quantity.must_equal qty_requested * 2
      must_respond_with :redirect
      must_redirect_to cart_path
    end

    it "updates the qty requested if the order item is already in the cart for a merchant who doesn't own the product" do
      login(not_plushie_merchant)
      product = plushie
      qty_requested = 7
      order_item_data = {
        order_item: {
          quantity: qty_requested,
          product_id: product.id
        }
      }

      post order_items_path, params: order_item_data

      expect {
        post order_items_path, params: order_item_data
      }.wont_change('OrderItem.count')

      OrderItem.last.quantity.must_equal qty_requested * 2
      must_respond_with :redirect
      must_redirect_to cart_path
    end

    it "redirects the merchant if they try to purchase their own product" do
      login(plushie_merchant)
      product = plushie
      qty_requested = 7
      order_item_data = {
        order_item: {
          quantity: qty_requested,
          product_id: product.id,
        }
      }
      expect {
        post order_items_path, params: order_item_data
      }.wont_change('OrderItem.count')

      must_respond_with :redirect
      must_redirect_to dashboard_path
    end
  end

  describe "Update" do
    it "successfully updates the Order Item quantity with a pending status" do
      order_item = order_items(:pending)
      original_qty = order_item.quantity
      updated_qty = original_qty + 1

      patch order_item_path(order_item.id), params: {
        order_item: {
          quantity: updated_qty
        }
      }
      order_item.reload
      order_item.quantity.must_equal updated_qty
      must_redirect_to cart_path
    end

    it "renders a 404 not_found for bogus order item data" do
      order_item = order_items(:pending)
      original_qty = order_item.quantity

      patch order_item_path(order_item.id), params: {
        order_item: {
          quantity: 'four'
        }
      }
      must_redirect_to root_path
      order_item.quantity.must_equal original_qty
    end

    it "renders a bad request if the quantity updated is more than the product inventory" do
      order_item = order_items(:pending)
      original_qty = order_item.quantity
      bad_qty = original_qty + 100

      patch order_item_path(order_item.id), params: {
        order_item: {
          quantity: bad_qty
        }
      }

      order_item.quantity.must_equal original_qty
      must_redirect_to root_path
    end

    it "renders a bad request if the quantity updated is good but the status is paid" do
      paid_order_item = order_items(:paid)
      original_qty = paid_order_item.quantity
      good_qty = original_qty + 1

      patch order_item_path(paid_order_item.id), params: {
        order_item: {
          quantity: good_qty
        }
      }

      paid_order_item.quantity.must_equal original_qty
      must_redirect_to root_path
    end

    it "renders a bad request if the quantity updated is good but the status is cancelled" do
      paid_order_item = order_items(:cancelled)
      original_qty = paid_order_item.quantity
      good_qty = original_qty + 1

      patch order_item_path(paid_order_item.id), params: {
        order_item: {
          quantity: good_qty
        }
      }

      paid_order_item.quantity.must_equal original_qty
      must_redirect_to root_path
    end

    it "renders a bad request if the quantity updated is good but the status is shipped" do
      paid_order_item = order_items(:shipped)
      original_qty = paid_order_item.quantity
      good_qty = original_qty + 1

      patch order_item_path(paid_order_item.id), params: {
        order_item: {
          quantity: good_qty
        }
      }

      paid_order_item.quantity.must_equal original_qty
      must_redirect_to root_path
    end
  end

  describe "Update Order Item Status" do
    it "updates the status to shipped if it has the right merchant associated with the order item" do
      paid_order_item = order_items(:paid)
      merchant = paid_order_item.merchant
      login(merchant)
      paid_order_item.status.must_equal "paid"

      patch update_order_item_status_path(paid_order_item.id), params: { status: "shipped" }

      paid_order_item.reload
      paid_order_item.status.must_equal "shipped"
      must_redirect_to dashboard_path
    end

    it "updates the status to cancelled if it has the right merchant associated with the order item" do
      paid_order_item = order_items(:paid)
      merchant = paid_order_item.merchant
      login(merchant)
      paid_order_item.status.must_equal "paid"

      patch update_order_item_status_path(paid_order_item.id), params: { status: "cancelled" }

      paid_order_item.reload
      paid_order_item.status.must_equal "cancelled"
      must_redirect_to dashboard_path
    end

    it "does not update the status if a Merchant tries to update an order item to shipped that is not associated with them" do
      paid_order_item = order_items(:paid)
      merchant = plushie_merchant
      login(merchant)
      good_qty = paid_order_item.quantity
      paid_order_item.status.must_equal "paid"

      patch update_order_item_status_path(paid_order_item.id), params: { status: "shipped" }

      paid_order_item.reload
      paid_order_item.status.must_equal "paid"
      must_redirect_to dashboard_path
    end

    it "does not update the status if a Merchant tries to update an order item to shipped that is not associated with them" do
      paid_order_item = order_items(:paid)
      merchant = plushie_merchant
      login(merchant)
      paid_order_item.status.must_equal "paid"

      patch update_order_item_status_path(paid_order_item.id), params: { status: "cancelled" }

      paid_order_item.reload
      paid_order_item.status.must_equal "paid"
      must_redirect_to dashboard_path
    end

    it "does not update the status if a guest user tries to change the status to shipped" do
      paid_order_item = order_items(:paid)
      paid_order_item.status.must_equal "paid"

      patch update_order_item_status_path(paid_order_item.id), params: { status: "shipped" }

      paid_order_item.reload
      paid_order_item.status.must_equal "paid"
      must_redirect_to dashboard_path

    end

    it "does not update the status if a guest user tries to change the status to cancelled" do
      paid_order_item = order_items(:paid)
      paid_order_item.status.must_equal "paid"

      patch update_order_item_status_path(paid_order_item.id), params: { status: "cancelled" }

      paid_order_item.reload
      paid_order_item.status.must_equal "paid"
      must_redirect_to dashboard_path
    end

    it "does not update the status for a bogus status with a logged in merchant who has the product" do
      paid_order_item = order_items(:paid)
      merchant = paid_order_item.merchant
      login(merchant)
      paid_order_item.status.must_equal "paid"

      patch update_order_item_status_path(paid_order_item.id), params: { status: "bogus" }

      paid_order_item.reload
      paid_order_item.status.must_equal "paid"
      must_redirect_to dashboard_path
    end
  end

  describe "Destroy" do
    it "deletes an order item when status is pending" do
      order_item = order_items(:pending)
      order = order_item.order

      expect{
        delete order_item_path(order_item.id)
      }.must_change('order.order_items.count', -1)

      must_respond_with :redirect
      must_redirect_to cart_path
    end

    it "does not delete order item if status is paid" do
      order_item = order_items(:paid)
      order = order_item.order

      expect {
        delete order_item_path(order_item.id)
      }.wont_change('order.order_items.count')

      must_redirect_to root_path
    end

    it "does not delete order item if status is cancelled" do
      order_item = order_items(:cancelled)
      order = order_item.order

      expect {
        delete order_item_path(order_item.id)
      }.wont_change('order.order_items.count')

      must_redirect_to root_path
    end

    it "does not delete order item if status is shipped" do
      order_item = order_items(:shipped)
      order = order_item.order

      expect {
        delete order_item_path(order_item.id)
      }.wont_change('order.order_items.count')

      must_redirect_to root_path
    end
  end
end
