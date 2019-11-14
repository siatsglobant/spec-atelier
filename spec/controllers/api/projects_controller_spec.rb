describe Api::ProjectsController, type: :controller do
  let(:user) { create(:user) }
  let(:no_logged_user) { create(:user) }
  let(:session) { create(:session, user: user, token: session_token(user)) }
  let(:project) { create(:project) }

  describe '#index' do
    context 'without session' do
      before { get :index, params: { user_id: no_logged_user.id } }
      it_behaves_like 'an unauthorized api request'
    end

    context 'with valid session' do
      it 'returns list of projects that belongs to user with session initialized' do
        create_list(:project, 3, user: user)
        request.headers['Authorization'] = "Bearer #{session.token}"
        get :index, params: { user_id: user.id }

        expect(json.count).to eq(3)
        expect(json.first['name']).to eq('fake project 3')
        expect(json.second['name']).to eq('fake project 2')
        expect(json.third['name']).to eq('fake project 1')
        expect(json.first.keys).to match_array(%w[id name project_type work_type country city delivery_date status created_at updated_at])
      end
    end
  end

  describe '#show' do
    context 'without session' do
      before { get :show, params: { user_id: no_logged_user.id, id: project.id } }
      it_behaves_like 'an unauthorized api request'
    end

    context 'with valid session' do
      it 'returns a resource' do
        request.headers['Authorization'] = "Bearer #{session.token}"
        get :show, params: { user_id: user.id, id: project.id }

        expect(json['name']).to eq(project.name)
      end
    end
  end

  describe '#create' do
    context 'without session' do
      before { post :create, params: { user_id: no_logged_user.id } }
      it_behaves_like 'an unauthorized api request'
    end

    context 'with valid session' do
      it 'creates a project' do
        request.headers['Authorization'] = "Bearer #{session.token}"
        post :create, params: { user_id: user.id, project: { name: 'fake project', project_type: 'real_state', work_type: 'new_building'  } }

        expect(Project.last.name).to eq('fake project')
        expect(Project.last.user.id).to eq(user.id)
        expect(response).to have_http_status(:created)
      end
    end
  end

  describe '#delete' do
    it 'soft deletes a project' do
      request.headers['Authorization'] = "Bearer #{session.token}"
      delete :destroy, params: { user_id: user.id, id: project.id }

      expect(project.soft_deleted).to eq(false)
      expect(project.reload.soft_deleted).to eq(true)
    end
  end

  describe '#search' do
    before do
      create(:project, name: 'abc abd aci', user: user)
      create(:project, name: 'bca abc abi', user: user)
      create(:project, name: 'bca abd abi', user: user)
    end

    context 'without session' do
      before { get :search, params: { user_id: no_logged_user.id } }
      it_behaves_like 'an unauthorized api request'
    end

    context 'with valid session' do
      it 'searchs for projects containing matching with searched keywords' do
        request.headers['Authorization'] = "Bearer #{session.token}"
        get :search, params: {  user_id: user.id, search_keywords: 'c ab' }

        expect(json.count).to eq(2)
      end
    end
  end

  describe '#update' do
    it 'updates a project' do
      request.headers['Authorization'] = "Bearer #{session.token}"
      patch :update, params: { user_id: user.id, id: project.id, project: { name: 'new name', project_type: 'residential' } }

      expect(project.reload.name).to eq('new name')
      expect(project.reload.project_type).to eq('residencial')
    end
  end
end
