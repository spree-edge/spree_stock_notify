Spree::Core::Engine.add_routes do

  resource :stock_notify, only: [:create]
  
end
