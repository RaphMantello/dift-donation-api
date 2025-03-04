Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'auth/sign_up', to: 'auth#sign_up'
      post 'auth/login', to: 'auth#login'

      resources :donations, only: %i[create]
      get 'donations/user_total', to: 'donations#user_total'
    end
  end
end
