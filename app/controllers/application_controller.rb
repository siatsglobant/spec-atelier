class ApplicationController < ActionController::API
  include SessionManipulator
  include ::ActionController::Cookies
end
