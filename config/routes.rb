Rails.application.routes.draw do
  resources :sessions, only: %i[create]
  delete :logout, to: 'sessions#logout'
  delete :logged_in, to: 'sessions#logged_in'

  resources :registrations, only: %i[create]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
