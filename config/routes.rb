Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do
      resources :players, only: %i[create index update] do
        collection do
          get :current_player
        end
      end
      resources :challenges, only: %i[create update destroy]
      resources :pledges, only: %i[create index update destroy] do
        member do
          patch :mark_as_done
        end
      end
      resources :games, only: %i[create update] do
        collection do
          get :active_game
        end
      end
    end
  end

end
