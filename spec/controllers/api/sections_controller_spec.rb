describe Api::SectionsController, type: :controller do
  let(:user)           { create(:user) }
  let(:no_logged_user) { create(:user) }
  let(:session)        { create(:session, user: user, token: session_token(user)) }

  describe '#sections' do
    context 'without session' do
      before { get :index, params: { user_id: no_logged_user.id } }
      it_behaves_like 'an unauthorized api request'
    end

    context 'with valid session' do
      it 'returns list of projects that belongs to user with session initialized' do
        request.headers['Authorization'] = "Bearer #{session.token}"
        create_list(:section, 9)
        get :index, params: { user_id: user.id }

        expect(response).to have_http_status(:ok)
        expect(json['sections'].count).to eq(9)
      end
    end
  end
end