class LookupTable < ApplicationRecord
  scope :by_category, ->(category) { where(category: category) }
  CATEGORIES = %w[project_type work_type room_type].freeze

end
