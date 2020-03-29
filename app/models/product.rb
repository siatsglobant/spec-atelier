class Product < ApplicationRecord
  include MetaLookupTable
  belongs_to :brand
end
