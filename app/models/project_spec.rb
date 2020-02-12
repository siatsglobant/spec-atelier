class ProjectSpec < ApplicationRecord
  belongs_to :project
  belongs_to :item
  belongs_to :subitem
  belongs_to :spec_text, optional: true
  belongs_to :product, optional: true
  has_one :user, through: :project
end
