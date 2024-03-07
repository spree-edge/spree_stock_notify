Spree::Core::Engine.add_routes do
  namespace :api, defaults: { format: 'json' } do
    namespace :v2 do
      namespace :storefront do
        resources :products do
          # resources :stock_notify
          put :stock_notify, on: :member
        end
      end
    end
    end
end
