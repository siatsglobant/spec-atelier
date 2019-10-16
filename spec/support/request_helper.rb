module Request
  def json
    JSON.parse(response.body)
  end

  def session_token(user)
    JsonWebToken.encode({ user_id: user.id })
  end
end