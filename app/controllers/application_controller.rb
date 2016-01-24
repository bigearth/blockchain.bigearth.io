class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :get_coin_value
    
  def get_coin_value
    coin_info = HTTParty.get 'http://btc.blockr.io/api/v1/coin/info' 
    @value = coin_info['data']['markets']['coinbase']['value']
  end
end
