class MerchantsController < ApplicationController

  def show
    @products = @current_merchant.products
    @order_items = []
    @products.each do |product|
       all_items = OrderItem.where( product_id: product.id )
       all_items.each do |order_item|
         if order_item.status != 'pending'
           @order_items << order_item
         end
       end
     end
  end

end
