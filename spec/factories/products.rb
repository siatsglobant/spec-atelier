FactoryBot.define do
  factory :product do
    sequence(:name) {|n| "fake product #{n}" }
    subitem { create(:subitem) }
    brand { create(:brand) }
  end
end
