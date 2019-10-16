class UserNotifierMailer < ApplicationMailer
  default from: 'paul.eaton@specatelier.com'

  def send_signup_email(user)
    @user = user
    mail(to: 'san.storres@gmail.com', subject: 'Thanks for signing up for our amazing app')
  end
end
