Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :fetch, only: [] do
        url_action = -> (entity) do
          { ':entity/:prefix/:name' => :show, entity: entity }
        end

        %i(users).each do |entity|
          collection do
            get  url_action.call(entity)
            post url_action.call(entity)
          end
        end
      end
    end
  end

  match ':not_found' => 'errors#not_found', constraints: { not_found: /.*/ }, via: [:all]
end
