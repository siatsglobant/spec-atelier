FactoryBot.define do
  factory :subitem do
    sequence(:name) {|n| "fake subitem #{n}" }
    item { create(:item)}
  end
end
