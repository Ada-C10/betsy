class MakeProductIdInReviewsAndMerchantIdInProductsSingular < ActiveRecord::Migration[5.2]
  def change
    remove_reference :reviews, :products, foreign_key: true
    add_reference :reviews, :product, foreign_key: true

    remove_reference :products, :merchants, foreign_key: true

    add_reference :products, :merchant, foreign_key: true
  end
end
