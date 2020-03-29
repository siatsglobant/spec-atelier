FactoryBot.define do
  factory :section do
    sequence(:name) {|n| "fake section #{n}" }
  end
end
