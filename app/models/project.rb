class Project < ApplicationRecord
  include MetaLookupTable
  belongs_to :user
  default_scope { where(soft_deleted: false) }
  enum status: { active: 1, closed: 0 }
  enum visibility: { public_available: 0, creator_only: 1 }

  scope :search, ->(keywords) { where('name LIKE ?', "%#{keywords}%") }
end
