require "test_helper"

describe Category do
  let(:category) { Category.new }
  let(:readables) { categories(:readables) }

#   describe 'relations' do
#     it 'responds to products' do
#       expect(readables).must_respond_to :products
#
#       readables.products.each do |product|
#         expect(product).must_be_kind_of Product
#       end
#     end
#
#     it 'can have products' do
#       expect(readables).must_include products(:poodr)
#     end
#
#     it 'can have zero products' do
#       expect(readables).must_include products(:poodr)
#     end
#   end
#
# describe 'validations' do
#   it "must be valid" do
#     value(category).must_be :valid?
#   end
#
#   it 'requires a category name present' do
#     expect(readables.valid?).must_equal true
#
#     readables.category_name = nil
#
#     expect(category.valid?).must_equal false
#     expect(category.errors.messages).must_include :category_name
#   end
#
#   it 'requires a unique name' do
#     cozyables = categories(:cozyables)
#     wearables = categories(:wearables)
#     cozyables.username = wearables.username
#
#     expect(cozyables.valid?).must_equal false
#     expect(cozyables.errors.messages).must_include :category_name
#
#     cozyables.username = "cozyables"
#     expect(cozyables.valid?).must_equal true
#   end
# end

describe 'model logic' do
  # TODO: add tests for business logic below
end
end
