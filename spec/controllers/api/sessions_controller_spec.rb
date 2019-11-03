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
        expect(json.keys).to match_array(%w[logged_in user])
        expect(json['user'].keys).to match_array(%w[email jwt])
      end
    end

    describe 'when user does not exists' do
      before { get :create, params: { user: { email: 'not_existing_mail@test.com', password: '123456' } }}

      it 'returns created status' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe '#google_auth' do
    before { post :google_auth, params: { user: { name: 'name', last_name: 'last_name', google_token: 'token', email: 'not_existing_mail@test.com' } }}

    it 'returns created status' do
      expect(response).to have_http_status(:created)
      expect(json.keys).to match_array(%w[logged_in user])
      expect(json['user'].keys).to match_array(%w[email jwt])
      expect(User.last.name).to eq('name')
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
