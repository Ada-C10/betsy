require "test_helper"

#Sammi Joo
# describe Product do
#   let(:product) { Product.new }
#
#   describe "relations" do
#     it "has a list of votes" do
#        album = works(:album)
#        album.must_respond_to :votes
#        album.votes.each do |vote|
#          vote.must_be_kind_of Vote
#        end
#     end
#
#     it "has a list of voting users" do
#       album = works(:album)
#       album.must_respond_to :ranking_users
#       album.ranking_users.each do |user|
#         user.must_be_kind_of User
#       end
#     end
#   end
#
#   describe "relations" do
#     it "has a user" do
#       v = votes(:one)
#       v.must_respond_to :user
#       v.user.must_be_kind_of User
#     end
#
#     it "has a work" do
#       v = votes(:one)
#       v.must_respond_to :work
#       v.work.must_be_kind_of Work
#     end
#   end
#
#   describe "relations" do
#     it "has a list of votes" do
#       dan = users(:dan)
#       dan.must_respond_to :votes
#       dan.votes.each do |vote|
#         vote.must_be_kind_of Vote
#       end
#     end
#
#     it "has a list of ranked works" do
#       dan = users(:dan)
#       dan.must_respond_to :ranked_works
#       dan.ranked_works.each do |work|
#         work.must_be_kind_of Work
#       end
#     end
#   end
# end
#
# describe "validations" do
#   it "requires a name" do
#     product = Product.new
#     product.valid?.must_equal false
#     product.errors.messages.must_include :name
#   end
# end



# validates :name, presence: true, uniqueness: true
# validates :cost, presence: true, numericality: { greater_than: 0 }, allow_nil: true
# validates :inventory, presence: true, numericality: { only_integer: true }
# validates :description, presence: true
# validates :active, inclusion: { in: [true, false] }
# validates :image_url, presence: true
