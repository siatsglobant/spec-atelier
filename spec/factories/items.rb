FactoryBot.define do
  factory :item do
    sequence(:name) {|n| "fake item #{n}" }
    section { create(:section) }
  end
end
