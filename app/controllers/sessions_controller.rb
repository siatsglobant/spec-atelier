class SessionsController < ApplicationController
  include CurrentUserConcern
  before_action :set_current_user, except: %i[create logout]
  before_action :valid_session, except: :create

  def create
    user = User.find_by(email: params['user']['email']).try(:authenticate, params['user']['password'])
    if user
      cookies.signed[:jwt] = { value: JsonWebToken.encode(user_id: user.id), httponly: true, expires: 1.hour.from_now }
      render json: { status: :created, logged_in: true, user: user, jwt: cookies.signed[:jwt] }
    else
      render json: { status: :not_found }
    end
  end

  def logged_in
    if current_user.present?
      render json: { logged_in: true, user: current_user, jwt: cookies.signed[:jwt] }
    else
      render json: { logged_in: false }
    end
  end

  def anything
    render json: current_user
  end

  def logout
    cookies.delete(:jwt)
    render json: { status: :ok, logged_out: true }
  end
end
