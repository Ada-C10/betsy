class StatusController < ApplicationController
  def findform
  end

  # post route
  def detail
    @order = Order.find_by(id: params[:id])
    orderitems = OrderItem.where(order_id: params[:id])
    ids_items_purchased = orderitems.map do |item|
      item.item_id
    end

    quantity_per_item = orderitems.map do |item|
      item.quantity_per_item
    end

    items_purchased = []
    ids_items_purchased.each do |id|
      item = Item.find_by(id: id)
      items_purchased << item
    end

    @order_info = {}

    index = 0
    while index < items_purchased.length do
      @order_info[items_purchased[index]] = quantity_per_item[index]
      index += 1
    end

  end

  # get route
  def show
    @order = Order.find_by(id: params[:id])
    orderitems = OrderItem.where(order_id: params[:id])

    ids_items_purchased = orderitems.map do |item|
      item.item_id
    end

    quantity_per_item = orderitems.map do |item|
      item.quantity_per_item
    end

    items_purchased = []
    ids_items_purchased.each do |id|
      item = Item.find_by(id: id)
      items_purchased << item
    end

    @order_info = {}

    index = 0
    while index < items_purchased.length do
      @order_info[items_purchased[index]] = quantity_per_item[index]
      index += 1
    end

  end
end
