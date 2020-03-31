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
      before do
        request.headers['Authorization'] = "Bearer #{session.token}"
      end

      it 'returns list of products that belongs to item' do
        create_list(:product, 11, subitem: subitem)
        get :products, params: { user_id: user.id, item_id: item, limit: 5, page: 0, offset: 5}

        expect(response).to have_http_status(:ok)
        expect(json['products']['total']).to eq(11)
        expect(json['products']['list'].count).to eq(5)
        expect(json['products']['list'].first['name']).to eq('fake product 1')
        expect(json['products']['list'].first['system']['name']).to eq(subitem.name)

        get :products, params: { user_id: user.id, item_id: item, limit: 5, page: 1, offset: 5 }

        expect(response).to have_http_status(:ok)
        expect(json['products']['next_page']).to eq(2)
        expect(json['products']['total']).to eq(11)
        expect(json['products']['list'].count).to eq(5)
        expect(json['products']['list'].first['name']).to eq('fake product 6')

        get :products, params: { user_id: user.id, item_id: item, limit: 5, page: 2, offset: 5 }

        expect(response).to have_http_status(:ok)
        expect(json['products']['next_page']).to eq(nil)
        expect(json['products']['total']).to eq(11)
        expect(json['products']['list'].count).to eq(1)
        expect(json['products']['list'].first['name']).to eq('fake product 11')
      end

      it 'returns list of products that belongs to item2' do
        products = create_list(:product, 5, subitem: subitem2)
        get :products, params: { user_id: user.id, item_id: item2, limit: 5, page: 0, offset: 5 }

        expect(response).to have_http_status(:ok)
        expect(json['products']['total']).to eq(item2.products.count)
        expect(json['products']['list'].first['brand']['name']).to eq(products.first.brand.name)
        expect(json['products']['list'].first['system']['name']).to eq(subitem2.name)
      end
    end
  end
end