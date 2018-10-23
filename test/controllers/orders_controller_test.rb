require "test_helper"
require 'pry'

describe OrdersController do
  let(:order_one) {orders(:one)}
  let(:order_three) {orders(:three)}

  describe "index" do
    it "should get index" do
      get cart_path
      must_respond_with :success
    end
  end

  describe "show" do
    it "should respond with success for showing an existing order with order_items  " do
      get order_path(order_three.id)
      must_respond_with :success
    end

    it "should respond with not found for showing a non-existing order" do
      order = orders(:two)

      order.order_items.destroy_all
      order.destroy

      get order_path(order.id)
      must_respond_with :not_found
    end
  end

  describe "edit" do
    it "responds with success for an existing order" do
      product = products(:plushie)
      order_item_data = {
        order_item: {
          quantity: 7,
          product_id: product.id
        }
      }

      post order_items_path, params: order_item_data
      get checkout_path
      must_respond_with :success
    end

    it "responds with error, cart is empty and redirects to root if try to edit empty cart." do
      get checkout_path
      must_respond_with :redirect
    end
  end

  describe "update" do
    before do
      @order = orders(:four)
    end

    it "Updates the order billing params successfully" do
      @order.email.must_equal nil
      @order.mailing_address.must_equal nil
      @order.cc.must_equal nil
      @order.cc_name.must_equal nil
      @order.cc_expiration.must_equal nil
      @order.cvv.must_equal nil
      @order.zip.must_equal nil
      @order.status.must_equal 'cart'

      put order_path(@order.id), params:{
        order: {
          email: "bbb@gmail.com",
          mailing_address: '2334 B Street',
          cc: 1234123412341234,
          cc_name: 'Some Name',
          cc_expiration: '10/23',
          cvv: 987,
          zip: 98123,
        }
      }

      updated_order = Order.find_by(id: @order.id)
      updated_order.email.must_equal "bbb@gmail.com"
      updated_order.mailing_address.must_equal "2334 B Street"
      updated_order.cc.must_equal "1234123412341234"
      updated_order.cc_name.must_equal "Some Name"
      updated_order.cc_expiration.must_equal "10/23"
      updated_order.cvv.must_equal "987"
      updated_order.zip.must_equal "98123"
      updated_order.status.must_equal 'paid'
      must_redirect_to order_path(@order.id)
    end


    it "will change the status of each order item from 'pending' to 'paid'" do

      @order.order_items.each do |order_item|
        order_item.must_equal 'pending'
      end

      put order_path(@order.id), params:{
        order: {
          email: "bbb@gmail.com",
          mailing_address: '2334 B Street',
          cc: 1234123412341234,
          cc_name: 'Some Name',
          cc_expiration: '10/23',
          cvv: 987,
          zip: 98123,
        }
      }

      updated_order = Order.find_by(id: @order.id)

      updated_order.order_items.each do |order_item|
        order_item.must_equal 'paid'
      end
    end

    it "will render a bad request if there is missing data" do
      put order_path(@order.id), params:{
        order: {
          email: nil,
          mailing_address: '2334 B Street',
          cc: nil,
          cc_name: 'Name',
          cc_expiration: nil,
          cvv: nil,
          zip: nil,
        }
      }

      updated_order = Order.find_by(id: @order.id)
      updated_order.email.must_equal nil
      updated_order.mailing_address.must_equal nil
      updated_order.cc.must_equal nil
      updated_order.cc_name.must_equal nil
      updated_order.cc_expiration.must_equal nil
      updated_order.cvv.must_equal nil
      updated_order.zip.must_equal nil
      updated_order.status.must_equal 'cart'

      must_respond_with :error
    end
  end
  #
  #
  # describe "destroy" do
  #   it "can destroy an existing order" do
  #     # Arrange
  #     order = orders(:one)
  #     # before_order_count = Book.count
  #
  #     # Act
  #     expect {
  #       delete order_path(order)
  #     }.must_change('puts "inside the must_change argument"; Order.count', -1)
  #
  #     # Assert
  #     must_respond_with :redirect
  #     must_redirect_to orders_path
  #
  #     # expect(Book.count).must_equal(
  #     #   before_order_count - 1,
  #     #   "order count did not decrease"
  #     # )
  #   end
  #
  #   # it "responds with not_found if the order doesn't exist" do
  #   #   id = bad_order_id
  #   #   expect {
  #   #     delete order_path(id)
  #   #   }.wont_change('Book.count')
  #   #
  #   #   must_respond_with :not_found
  #   # end
  # end



end
