class JsonWebToken
  SECRET_KEY = Rails.application.secrets.secret_key_base.to_s

  def self.encode(payload, expires = 24.hours.from_now)
    payload[:expires] = expires.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(jwt)
    decoded = JWT.decode(jwt, SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  end
end
