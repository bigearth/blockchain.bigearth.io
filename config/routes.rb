Rails.application.routes.draw do
  root 'explorers#index'
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
  get 'charts/transaction_daily' => 'charts#transaction_daily'
  get 'charts/transaction_total' => 'charts#transaction_total'
  resources :explorers, only: [:index], path: 'coin'
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
