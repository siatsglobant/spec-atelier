class Section < ApplicationRecord
  has_many :items, dependent: :delete_all
end
