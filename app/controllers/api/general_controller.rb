module Api
  class GeneralController < ApplicationController
    before_action :valid_session

    def cities
      render json: { cities: CITIES.values.flatten }, status: :ok
    end
  end
end
