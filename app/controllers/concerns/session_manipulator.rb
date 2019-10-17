module SessionManipulator
  extend ActiveSupport::Concern

  def set_current_user
    @set_current_user ||= begin
      if cookies.signed[:jwt] || auth_header.present?
        token = cookies.signed[:jwt] || auth_header
        user_id = JsonWebToken.decode(token)[:user_id]
        User.find(user_id)
      end
    end
  end

  def current_user
    set_current_user
  end

  def current_session
    @current_session ||= current_user.session if current_user.session.active?
  end

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
    request_token = auth_header
    request_token.present? && current_session.active? && request_token == current_session.token
  end

  def auth_header
    request.headers["Authorization"]&.remove('Bearer ')
  end
end
