module Api
  class LookupTablesController < ApplicationController
    before_action :valid_session

    LookupTable::CATEGORIES.each do |category|
      define_method "#{category}s" do
        render json: { category.to_sym => LookupTable.by_category(category) }, status: :ok
      end
    end
  end
end
