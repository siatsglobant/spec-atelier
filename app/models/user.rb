class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
  has_one :session
  has_many :projects

  def generate_password_token!
    update(reset_password_token: SecureRandom.hex(10), reset_password_sent_at: Time.zone.now)
  end

  def password_token_valid?
    (reset_password_sent_at + 4.hours) > Time.now.utc
  end

  def reset_password!(password)
    update(reset_password_token: nil, password: password)
  end
end
