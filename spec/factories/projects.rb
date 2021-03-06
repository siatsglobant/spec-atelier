FactoryBot.define do
  factory :project do
    sequence(:name) {|n| "fake project #{n}" }
    user { create(:user) }
    project_type { 1 }
    work_type { 1 }
    status { 0 }
    visibility { 0 }
    soft_deleted { false }
  end
end
