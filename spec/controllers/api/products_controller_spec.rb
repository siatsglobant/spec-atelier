RSpec.describe Api::ProductsController, type: :controller do
  let(:user)           { create(:user) }
  let(:no_logged_user) { create(:user) }
  let(:session)        { create(:session, user: user, token: session_token(user)) }
  let(:products)       { create_list(:product, 10)}


  describe '#show' do
    context 'without session' do
      before { get :show, params: { user_id: no_logged_user.id, id: products.first.id } }
      it_behaves_like 'an unauthorized api request'
    end

    context 'with valid session' do
      before { request.headers['Authorization'] = "Bearer #{session.token}"}

      it 'returns a resource' do
        product = create(:product)
        get :show, params: { id: product.id }
        expect(json['product']['name']).to eq(product.name)
      end

      it 'returns a another resource' do
        get :show, params: { id: products.second.id }
        expect(json['product']['name']).to eq(products.second.name)
      end
    end
  end

end
