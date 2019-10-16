module Api
  class SessionsController < ApplicationController
    before_action :set_current_user, except: %i[create logout]
    before_action :valid_session, except: %i[create email_testing]

    def create
      user = User.find_by(email: params['user']['email']).try(:authenticate, params['user']['password'])
      if user.present?
        start_session(user)
        render json: { logged_in: true, user: user, jwt: current_session.token }, status: :created
      else
        render json: { status: 404 }, status: :not_found
      end
    end

    def logged_in
      if current_user.present?
        render json: { logged_in: true, user: current_user, jwt: current_session.token }
      else
        render json: { logged_in: false }
      end
    end

    def email_testing
      UserNotifierMailer.send_signup_email(current_user).deliver
    end

    def logout
      end_session
      render json: { logged_out: true }, status: :ok
    end
  end
end
