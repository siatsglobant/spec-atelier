FactoryBot.define do
  factory :session do
    active { true }
    expires { 24.hours.from_now }
  end
end
