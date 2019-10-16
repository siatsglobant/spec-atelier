module Api
  class RegistrationsController < ApplicationController
    def create
      user = User.new(email:                 params['user']['email'],
                      password:              params['user']['password'],
                      password_confirmation: params['user']['password'])
      if user.save
        start_session(user)
        render json: { logged_in: true, user: user, jwt: current_session.token }, status: :created
      else
        render json: { error: user.errors.to_json }, status: :internal_server_error
      end
    end
  end
end
