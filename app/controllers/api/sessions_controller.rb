module Api
  class SessionsController < ApplicationController
    before_action :set_current_user, except: %i[create logout]
    before_action :valid_session, except: %i[create]

    def create
      user = User.find_by(email: params['user']['email']).try(:authenticate, params['user']['password'])
      if user.present?
        start_session(user)
        render json: { logged_in: true, user: user, jwt: current_session.token }, status: :created
      else
        render json: { error: 'Email or password not found' }, status: :not_found
      end
    end

    def logged_in
      if current_user.present?
        render json: { logged_in: true, user: current_user, jwt: current_session.token }
      else
        render json: { logged_in: false }
      end
    end

    def logout
      end_session
      render json: { logged_out: true }, status: :ok
    end
  end
end
