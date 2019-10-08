class ApplicationController < ActionController::API
  include ::ActionController::Cookies

  def valid_session
    raise StandardError, "No session found" unless request.headers["X-CSRF-Token"] == cookies.signed[:jwt]
  end
end
