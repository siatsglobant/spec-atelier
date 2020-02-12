require 'rails_helper'
describe Api::LookupTablesController, type: :controller do
  let(:user)           { create(:user) }
  let(:no_logged_user) { create(:user) }
  let(:session)        { create(:session, user: user, token: session_token(user)) }

  describe '#fetch_categories' do
    before do
      create_list(:lookup_table, 2, category: 'work_type')
      create_list(:lookup_table, 3, category: 'project_type')
      create_list(:lookup_table, 4, category: 'room_type')
    end

    %w[work_type project_type room_type].each do |category|
      context 'without session' do
        before { get "#{category}s".to_sym, params: { user_id: no_logged_user.id } }
        it_behaves_like 'an unauthorized api request'
      end

      context 'with valid session' do
        it 'returns list of projects that belongs to user with session initialized' do
          request.headers['Authorization'] = "Bearer #{session.token}"
          get "#{category}s".to_sym, params: { user_id: user.id }

          expect(json[category].count).to eq(LookupTable.by_category(category).count)
        end
      end
    end
  end
end
