class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.text_search(query)
    if query.present?
      return search(query)
    else
      return []
    end
  end
end
