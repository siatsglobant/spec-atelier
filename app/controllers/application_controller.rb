class ApplicationController < ActionController::API
  include CurrentUser
  include SessionManipulator
  include ::ActionController::Cookies
end
