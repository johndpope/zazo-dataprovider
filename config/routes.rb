Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :fetch, only: [:show] do
        collection do
          get  ':name' => :show
          get  'users/:name' => :show, prefix: :users
          post 'users/:name' => :show, prefix: :users
        end
      end
    end
  end
end
