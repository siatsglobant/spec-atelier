class RegistrationsController < ApplicationController
  def create
    user = User.create!(email:                 params['user']['email'],
                        password:              params['user']['password'],
                        password_confirmation: params['user']['password'])
    if user
      render json: { status: :created, logged_in: true, user: user }
    else
      render json: { status: 500 }
    end
  end
end
