FactoryBot.define do
  factory :user do
    email    { 'email@test.com' }
    password { '123456' }

    trait :with_password_token do
      reset_password_token { 'token' }
      reset_password_sent_at { Time.zone.now }
    end
  end
end
