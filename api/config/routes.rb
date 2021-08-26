Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'
      resources :users, only: :show do
        resources :creators, controller: :user_creators, only: [:index, :create]
        resources :works, controller: :user_works, only: [:index, :create]
      end

      resources :creators, only: [:show, :update, :destroy] do
        resources :families, only: [:create, :destroy]
      end

      resources :works, only: [:show, :update, :destroy]
    end
  end
end
