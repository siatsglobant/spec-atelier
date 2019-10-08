module CurrentUserConcern
  extend ActiveSupport::Concern

  def set_current_user
    if cookies.signed[:jwt]
      user_id = JsonWebToken.decode(cookies.signed[:jwt])[:user_id]
      @current_user = User.find(user_id)
    else
      render json: { status: :unauthorized }
    end
  end

  def current_user
    @current_user
  end
end
