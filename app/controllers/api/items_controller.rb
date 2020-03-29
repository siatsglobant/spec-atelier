module Api
  class ItemsController < ApplicationController
    before_action :valid_session
    before_action :item, only: :products

    def products
      list = ::Products::ProductPresenter.decorate_list(item.products.includes(:subitem))
      render json: { item: { name: item.name, id: item.id }, products: list }
    end

    private

    def item
      @item ||= Item.find(params[:item_id])
    end
  end
end
