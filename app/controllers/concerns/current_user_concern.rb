module CurrentUserConcern
  extedn ActiveSupport::Concern

  included do
    before_action :set_current_user
  end

  def set_current_user
    @current_user = User.find(session[:user_id]) if session[:user_id]
  end

  def current_user
    @current_user
  end

end
