describe Api::ItemsController, type: :controller do
  let(:user)           { create(:user) }
  let(:no_logged_user) { create(:user) }
  let(:session)        { create(:session, user: user, token: session_token(user)) }
  let(:item)           { create(:item) }
  let(:subitem)        { create(:subitem, item: item) }
  let(:item2)          { create(:item) }
  let(:subitem2)       { create(:subitem, item: item2) }

  describe '#products' do
    context 'without session' do
      before { get :products, params: { user_id: no_logged_user.id, item_id: item} }
      it_behaves_like 'an unauthorized api request'
    end

    context 'with valid session' do
      before { request.headers['Authorization'] = "Bearer #{session.token}"}

      it 'returns list of products that belongs to item' do
        products = create_list(:product, 10, subitem: subitem)
        get :products, params: { user_id: user.id, item_id: item }

        expect(response).to have_http_status(:ok)
        expect(json['products'].count).to eq(item.products.count)
        expect(json['item']['name']).to eq(item.name)
        expect(json['products'].first['brand']['name']).to eq(products.first.brand.name)
        expect(json['products'].first['system']['name']).to eq(subitem.name)
      end

      it 'returns list of products that belongs to item2' do
        products = create_list(:product, 5, subitem: subitem2)
        get :products, params: { user_id: user.id, item_id: item2 }

        expect(response).to have_http_status(:ok)
        expect(json['products'].count).to eq(item2.products.count)
        expect(json['item']['name']).to eq(item2.name)
        expect(json['products'].first['brand']['name']).to eq(products.first.brand.name)
        expect(json['products'].first['system']['name']).to eq(subitem2.name)
      end
    end
  end
end