require 'rails_helper'
describe Api::PasswordsController, type: :controller do
  describe '#forgot' do
    describe 'when having problems with params' do
      it 'returns not found if email not passed in request' do
        get :forgot
        expect(response).to have_http_status(:not_found)
      end

      it 'returns not found if email is not found' do
        get :forgot, params: { email: 'fake_email@test.com' }
        expect(response).to have_http_status(:not_found)
      end
    end

    describe 'when user exists' do
      it 'returns proper response' do
        user = create(:user)
        get :forgot, params: { email: user.email }

        expect(response).to have_http_status(:ok)
        expect(user.reload.reset_password_token.present?).to be(true)
        expect(user.reload.reset_password_sent_at.present?).to be(true)
      end
    end
  end

  describe '#reset' do
    describe 'when having problems with params' do
      it 'returns not found if token not passed in request' do
        get :reset, params: { password: '123456' }
        expect(response).to have_http_status(:not_found)
      end

      it 'returns not found if password not passed in request' do
        get :reset, params: { token: '123456' }
        expect(response).to have_http_status(:not_found)
      end
    end

    describe 'when token and password is passed' do

      it 'returns ok status' do
        user = create(:user, :with_password_token )
        get :reset, params: { token: user.reset_password_token, password: '123456'}

        expect(response).to have_http_status(:ok)
      end
    end
  end
end