Rails.application.routes.draw do
  root 'explorers#index'
  mount Resque::Server, at: '/resque'
  devise_for :users, path_names: {
    verify_authy: "/verify-token",
    enable_authy: "/enable-two-factor",
    verify_authy_installation: "/verify-installation"
  }
  resources :users, except: [:index] do
    get 'confirm_node_created' => 'chains#confirm_node_created', path: 'chains/confirm_node_created'
    resources :chains
  end
  get 'blocks/transactions/:id' => 'blocks#transactions'
  get 'blocks/raw/:id' => 'blocks#raw'
  get 'transactions/raw/:id' => 'transactions#raw'
  get 'addresses/balance/:id' => 'addresses#balance'
  get 'addresses/unspent/:id' => 'addresses#unspent'
  get 'apps/bookmarks' => 'apps#bookmarks'
  get 'apps/calculator' => 'apps#calculator'
  get 'charts/show' => 'charts#show', path: 'charts'
  get 'charts/circulation' => 'charts#circulation'
  get 'charts/market_cap' => 'charts#market_cap'
  get 'charts/transaction_fees_btc' => 'charts#transaction_fees_btc'
  get 'charts/transaction_fees_usd' => 'charts#transaction_fees_usd'
  get 'charts/network_deficit' => 'charts#network_deficit'
  get 'charts/transactions_daily' => 'charts#transactions_daily'
  get 'charts/transactions_total' => 'charts#transactions_total'
  get 'charts/unique_addresses' => 'charts#unique_addresses'
  get 'charts/average_transactions' => 'charts#average_transactions'
  get 'charts/orphaned_blocks' => 'charts#orphaned_blocks'
  get 'charts/total_output_volume' => 'charts#total_output_volume'
  get 'charts/market_price' => 'charts#market_price'
  get 'charts/hash_rate' => 'charts#hash_rate'
  get 'charts/difficulty' => 'charts#difficulty'
  get 'charts/days_destroyed_cumulative' => 'charts#days_destroyed_cumulative'
  get 'charts/days_destroyed' => 'charts#days_destroyed'
  get 'charts/blockchain_size' => 'charts#blockchain_size'
  resources :explorers, only: [:index], path: 'coin'
  get 'explorers/cloud', path: 'cloud'
  resources :blocks, only: [:show]
  resources :transactions, only: [:show]
  resources :addresses, only: [:show]
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
