class Product < ApplicationRecord
  include MetaLookupTable
  belongs_to :brand
  belongs_to :subitem, optional: true
  has_one :item, through: :subitem
  # has_many :images, as: :owner, class_name: 'Image', autosave: true

end
