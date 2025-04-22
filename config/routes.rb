Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do
      resources :players, only: %i[create index update]
      resources :games, only: %i[create update] do
        collection do
          get :active_game
        end
      end
    end
  end

end
