describe Api::RegistrationsController, type: :controller do
  describe '#create' do
    it 'creates a user' do
      get :create, params: { user: { email: 'test@email.com', password: '123456' } }
      expect(User.last.email).to eq('test@email.com')
    end
  end
end