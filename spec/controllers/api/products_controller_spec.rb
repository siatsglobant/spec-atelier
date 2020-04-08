RSpec.describe Api::ProductsController, type: :controller do
  let(:user)           { create(:user) }
  let(:no_logged_user) { create(:user) }
  let(:session)        { create(:session, user: user, token: session_token(user)) }
  let(:products)       { create_list(:product, 10) }
  let(:product)        { create(:product) }

  describe '#show' do
    context 'without session' do
      before { get :show, params: { user_id: no_logged_user.id, id: products.first.id } }
      it_behaves_like 'an unauthorized api request'
    end

    context 'with valid session' do
      before do
        request.headers['Authorization'] = "Bearer #{session.token}"
      end

      it 'returns a resource' do
        image1 = create(:image, owner: product, order: 0)
        image2 = create(:image, owner: product, order: 1)

        get :show, params: { id: product.id }

        expect(json['product']['name']).to eq(product.name)
        expect(json['product']['images'].first['order']).to eq(image1.order)
        expect(json['product']['images'].first['urls']).to eq(image1.all_formats.as_json)
        expect(json['product']['images'].second['urls']).to eq(image2.all_formats.as_json)
      end

      it 'returns a another resource' do
        get :show, params: { id: products.second.id }
        expect(json['product']['name']).to eq(products.second.name)
      end
    end
  end
end
