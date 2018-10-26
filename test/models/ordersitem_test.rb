require "test_helper"
describe OrdersItem do
 let(:item) { orders_items(:item1) }
 it "must be valid" do
   item.valid?.must_equal true
 end

 it "must have required fields" do
   fields = [ :order_id, :product_id, :quantity]

   fields.each do |field|
     expect(item).must_respond_to field
   end
 end

 describe 'Relationships' do
   it 'belongs to order' do
     order = item.order

     expect(order).must_be_instance_of Order
     expect(order.id).must_equal item.order_id
   end

   it 'belongs to product' do
     product = item.product

     expect(product).must_be_instance_of Product
     expect(product.id).must_equal item.product_id
   end
 end

 describe 'Validations' do
   it 'has valid quantity' do
     qtys = ["s", :price, "134e", nil, -1]

     qtys.each do |qty|
       item.quantity = qty
       valid = item.save
       expect(valid).must_equal false
     end
   end

 end

 describe 'Custom Methods' do
   it 'can calculate total revenue for an item' do
     expect(item.calculate_total).must_equal 10.00*3
   end
 end
end
