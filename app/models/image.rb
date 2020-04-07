class Image < ApplicationRecord
  belongs_to :owner, polymorphic: true, optional: true
  scope :positioned, -> { order(order: :asc) }
  validates :url, uniqueness: true
  validates :name, uniqueness: { scope: :owner }
  validates :order, uniqueness: { scope: :owner }

  def all_formats
    %i[thumb small medium].each_with_object({}) {|key, h| h[key] = "#{url.gsub(name, '')}resized-#{key}-#{name}" }
  end
end
