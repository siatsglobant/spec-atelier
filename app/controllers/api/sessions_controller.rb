module Api
  class SessionsController < ApplicationController
    before_action :set_current_user, except: %i[create logout google_auth google_auth_failure]
    before_action :valid_session, except: %i[create google_auth google_auth_failure]

    def create
      user = User.find_by(email: params['user']['email'])
      if user.try(:authenticate, params['user']['password']).present?
        start_session(user)
        render json: { logged_in: true, user: BasicUserPresenter.to_print(current_user) }, status: :created
      elsif user&.google_token.present?
        render json: { error: 'you signed up with google' }, status: :not_found
      else
        render json: { error: 'email or password not found' }, status: :not_found
      end
    end

    def logged_in
      if current_user.present?
        render json: { logged_in: true, user: BasicUserPresenter.to_print(current_user) }, status: :ok
      else
        render json: { logged_in: false }, status: :not_found
      end
    end

    def logout
      end_session
      render json: { logged_out: true }, status: :ok
    end

    def google_auth
      access_token = request.env["omniauth.auth"]
      user = omniouth_handler_login(access_token)
      start_session(user)
      render json: { logged_in: true, user: BasicUserPresenter.to_print(current_user) }, status: :created
    end

    def google_auth_failure
      render json: { error: 'google auth failure' }, status: :internal_server_error
    end
  end
end
