FactoryBot.define do
  factory :project do
    sequence(:name) {|n| "fake project #{n}" }
    user { create(:user) }
    project_type { 'real_state' }
    work_type { 'new_building' }
    status { 0 }
    visibility { 0 }
    soft_deleted { false }
  end
end
