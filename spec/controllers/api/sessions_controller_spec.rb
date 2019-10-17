describe Api::SessionsController, type: :controller do
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user, token: session_token(user)) }

  describe '#create' do
    describe 'when user exists' do
      before { get :create, params: { user: { email: user.email, password: user.password } }}

      it 'creates a cookie' do
        expect(cookies.has_key? 'jwt').to be(true)
      end

      it 'creates a session' do
        expect(user.reload.session.present?).to be(true)
      end

      it 'returns created status' do
        expect(response).to have_http_status(:created)
      end
    end

    describe 'when user does not exists' do
      before { get :create, params: { user: { email: 'not_existing_mail@test.com', password: '123456' } }}

      it 'returns created status' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe '#logout' do
    describe 'when not sending header with token' do
      before { get :logout }

      it 'return anauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'when not sending header with token' do
      before do
        request.headers['Authorization'] = "Bearer #{session.token}"
        put :logout
      end

      it 'returns ok status' do
        expect(response).to have_http_status(:ok)
        expect(cookies.has_key? 'jwt').to be(false)
        expect(session.reload.active?).to be(false)
      end
    end
  end
end