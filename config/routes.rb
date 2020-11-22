Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :users
      post 'sign_in', action: :login, controller: 'users'
      post 'sign_out', action: :logout, controller: 'users'
    end
  end
end
