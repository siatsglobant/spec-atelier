module SessionManipulator
  extend ActiveSupport::Concern
  include CurrentUser

  def start_session(user)
    Session.find_or_create_by(user: user).update(token: set_token(user, 24.hours.from_now))
    set_current_user
  end

  def end_session
    current_session.update(active: false)
    cookies.delete(:jwt)
  end

  def valid_session
    render json: { error: 'No session found' }, status: :unauthorized unless valid_session_conditions
  end

  private

  def set_token(user, expires)
    token = JsonWebToken.encode({ user_id: user.id }, expires)
    cookies.signed[:jwt] = { value: token, httponly: true, expires: expires }
    token
  end

  def valid_session_conditions
    request_token = request.headers["X-CSRF-Token"]
    request_token.present? && current_session.active? && request_token == current_session.token
  end
end
