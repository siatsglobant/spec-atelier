class Subitem < ApplicationRecord
  belongs_to :item
  has_many :products
end
