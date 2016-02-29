Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :fetch, only: [] do
        %i(users).each do |entity|
          collection do
            get  ':entity/:prefix/:name' => :show, entity: entity
            post ':entity/:prefix/:name' => :show, entity: entity
          end
        end
      end
    end
  end

  get 'status',  to: Proc.new { [200, {}, ['']] }
  get 'version', to: Proc.new { [200, {}, ["#{Settings.app_name} #{Settings.version} (#{Rails.env})"]] }
  match ':not_found' => 'errors#not_found', constraints: { not_found: /.*/ }, via: [:all]
end
