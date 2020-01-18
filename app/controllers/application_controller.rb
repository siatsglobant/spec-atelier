class ApplicationController < ActionController::API
  include SessionManipulator
  include ::ActionController::Cookies

  rescue_from CanCan::AccessDenied do |exception|
    exception.default_message = 'You are not authorized'
    render json: { error: exception.message }, status: :forbidden
  end
end
