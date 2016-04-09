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
    resources :chains do
      # control
      get 'start'
      get 'stop'
      
      # blockchain
      get 'get_best_block_hash'
      get 'get_block'
      get 'get_blockchain_info'
      get 'get_block_count'
      get 'get_block_hash'
      get 'get_block_header'
      get 'get_chain_tips'
      get 'get_difficulty'
      get 'get_info'
      get 'get_mem_pool_info'
      get 'get_raw_mem_pool'
      get 'get_tx_out'
      get 'get_tx_out_proof'
      get 'get_tx_outset_info'
      get 'verify_chain'
      get 'verify_tx_out_proof'
      
      # generate
      get 'generate'
      get 'get_generate'
      get 'set_generate'
      
      # mining
      get 'get_block_template'
      get 'get_mining_info'
      get 'get_network_hashps'
      get 'prioritise_transaction'
      get 'submit_block'
      
      # network 
      get 'add_node'
      get 'disconnect_node'
      get 'get_added_node_info'
      get 'get_connection_count'
      get 'get_net_totals'
      get 'get_network_info'
      get 'get_peer_info'
      get 'list_banned'
      get 'clear_banned'
      get 'ping'
      get 'set_ban'
      
      # transaction
      get 'create_raw_transaction'
      get 'decode_raw_transaction'
      get 'decode_script'
      get 'get_raw_transaction'
      get 'send_raw_transaction'
      get 'sign_raw_transaction'

      # util
      get 'create_multi_sig'
      get 'estimate_fee'
      get 'estimate_priority'
      get 'estimate_smart_fee'
      get 'estimate_smart_priority'
      get 'validate_address'
      get 'verify_message'
    end
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
