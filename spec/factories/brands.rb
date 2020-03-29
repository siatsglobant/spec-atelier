FactoryBot.define do
  factory :brand do
    sequence(:name) {|n| "fake brand #{n}" }
  end
end
