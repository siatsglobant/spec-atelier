module Api
  class ProductsController < ApplicationController
    before_action :valid_session
    before_action :product, only: %i[show]

    def show
      render json: { product: ::Products::ProductPresenter.decorate(product) }, status: :ok
    end

    def create
      product = Product.new(product_params)
      if product.save
        render json: {}, status: :created
      else
        render json: { error: product.errors }, status: :unprocessable_entity
      end
    end

    def associate_images
      GoogleStorage.new(product, images_params[:images]).perform
      render json: {}, status: :created
    end

    def associate_documents
      GoogleStorage.new(product, documents_params[:documents]).perform
      render json: {}, status: :created
    end

    private

    def product
      @product ||= Product.find(params[:id] || params[:product_id])
    end

    def images_params
      params.require(:product).permit({ images: [] })
    end

    def documents_params
      params.require(:product).permit({ documents: [] })
    end

    def product_params
      permitted = %i[name brand_id subitem_id long_desc short_desc project_type work_type room_type]
      params.require(:product).permit(permitted)
    end
  end
end
