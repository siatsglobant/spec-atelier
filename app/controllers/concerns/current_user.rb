module CurrentUser
  extend ActiveSupport::Concern

  def set_current_user
    @set_current_user ||= begin
      if cookies.signed[:jwt] || request.headers["X-CSRF-Token"].present?
        token = cookies.signed[:jwt] || request.headers["X-CSRF-Token"]
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
end
