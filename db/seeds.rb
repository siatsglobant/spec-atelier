def console_message(message, status)
  meesage = '-' * 10 + message
  puts status ? "success: #{message}" : "error: #{message}"
end

Project.delete_all
puts 'projects deleted'

Session.delete_all
puts 'sessions deleted'

user = User.find_by(email: 'test@specatelier.com')
user&.delete ? console_message('user deleted', true) : console_message('user not deleted', false)

user = User.new(email: 'test@specatelier.com', name: 'Test', last_name: 'User', password: '123456', google_token: 'fake_token')
user&.save ? console_message('user created', true) : console_message('user not created', false)

10.times do |index|
  Project.create!(
    name: "Fake Project #{index}",
    project_type: Project.project_types.values.sample,
    work_type: Project.work_types.values.sample,
    country: Faker::Address.country,
    city: Faker::Address.city,
    delivery_date: Time.zone.now + 2.months,
    visibility: Project.visibilities.values.sample,
    status: 1,
    user: user
  )
end

Project.count == 10 ? console_message('projects created', true) : console_message('not all projects created', false)

