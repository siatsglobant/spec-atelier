Rails.application.routes.draw do

  namespace :api do
    resources :sessions, only: %i[create]
    put :logout, to: 'sessions#logout'
    get :logged_in, to: 'sessions#logged_in'
    resources :registrations, only: %i[create]

    get :password_forgot, to: 'passwords#forgot'
    get :password_reset, to: 'passwords#reset'

    resources :users, only: %i[] do
      get 'projects/search'
      resources :projects
    end
  end
  post 'auth/google_login_service', to: 'api/sessions#google_auth'

  # get 'auth/failure', to: 'api/sessions#google_auth_failure'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
