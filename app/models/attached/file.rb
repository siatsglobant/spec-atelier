module Attached
  class File < ApplicationRecord
    belongs_to :owner, polymorphic: true, optional: true
    scope :positioned, -> { order(order: :asc) }
    validates :url, uniqueness: true
    validates :name, uniqueness: { scope: :owner }
    validates :order, uniqueness: { scope: :owner }

  end
end
