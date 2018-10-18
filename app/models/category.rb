class Category < ApplicationRecord
  has_and_belongs_to_many :products

  validates :name, presence: true


# This is from MediaRanker-Revisited - it might be helpful. -sj
  # This is called a model filter, and is very similar to a controller filter.
  # We want to fixup the category *before* we validate, because
  # our validations are rather strict about what's OK.

  # before_validation :fix_category
  #
  # private
  # def fix_category
  #   if self.category
  #     self.category = self.category.downcase
  #   end
  # end
end
