module Api
  class GeneralController < ApplicationController
    before_action :valid_session

    def cities
      render json: { cities: CITIES.values.flatten }, status: :ok
    end

    def items_by_section
      section = Section.find_by(eng_name: params[:section])
      items = section.items.as_json(only: %i[id name])
      render json: { section: section.name,  items: items }, status: :ok
    end
  end
end
