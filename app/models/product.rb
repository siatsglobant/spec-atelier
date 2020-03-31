class Product < ApplicationRecord
  include MetaLookupTable
  belongs_to :brand
  belongs_to :subitem, optional: true
  has_one :item, through: :subitem

  def images
    [
      'https://dummyimage.com/400x400/cccccc/000000.png',
      'https://dummyimage.com/400x400/cccccc/000000.png',
      'https://dummyimage.com/400x400/cccccc/000000.png',
    ]
  end

end
