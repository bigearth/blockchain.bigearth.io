Rails.application.routes.draw do
  root 'explorers#index'
  mount Resque::Server, at: '/resque'
  get 'blocks/transactions/:id' => 'blocks#transactions'
  get 'blocks/raw/:id' => 'blocks#raw'
  get 'transactions/raw/:id' => 'transactions#raw'
  get 'addresses/balance/:id' => 'addresses#balance'
  get 'addresses/unspent/:id' => 'addresses#unspent'
  get 'apps/bookmarks' => 'apps#bookmarks'
  get 'apps/calculator' => 'apps#calculator'
  resources :explorers, only: [:index], path: 'coin'
  resources :blocks, only: [:show]
  resources :transactions, only: [:show]
  resources :addresses, only: [:show]
  namespace :platform do
    namespace :v1 do
      get 'get_chain' => 'chains#get_chain', path: 'chains/get_chain'
      post 'new_chain' => 'chains#new_chain', path: 'chains/new_chain'
      delete 'delete_chain' => 'chains#destroy_chain', path: 'chains/destroy_chain'
      get 'harden_chain' => 'chains#harden_chain', path: 'chains/harden_chain'
      get 'list_ssh_keys' => 'chains#list_ssh_keys', path: 'chains/list_ssh_keys'
      resources :chains
    end
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'explorers#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
