module Api
  class ProductsController < ApplicationController
    before_action :valid_session
    before_action :product, only: :show

    def show
      render json: { product: ::Products::ProductPresenter.decorate(product) }
    end

    private

    def product
      Product.find(params[:id])
    end
  end
end
