module Api
  class SectionsController < ApplicationController
    before_action :valid_session
    before_action :section, only: :products

    def index
      list = Section.all.order(:show_order).map {|section| { eng_name: section.eng_name, name: section.name } }
      render json: { sections: list }
    end

    private

    def section
      @section ||= Section.find(params[:id])
    end
  end
end
