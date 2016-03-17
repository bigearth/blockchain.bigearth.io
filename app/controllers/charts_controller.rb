class ChartsController < ApplicationController
  # before_action :set_transaction, only: [:edit, :update, :destroy]

  # GET /charts/show
  # GET /charts/show.json
  def show 
    # @tx = HTTParty.get "http://btc.blockr.io/api/v1/tx/info/#{params[:id]}" 
  end

  # GET /charts/circulation
  # GET /charts/circulation.json
  def circulation
    @circulations = Charts::Circulation.all.map do |item| 
      [item['time'], item['total'].to_i]
    end 
  end

  # GET /charts/market_cap
  # GET /charts/market_cap.json
  def market_cap
    @market_cap = Charts::MarketCap.all.map do |item| 
      [item['time'], item['total'].to_i]
    end 
  end

  # GET /charts/transaction_fees_btc
  # GET /charts/transaction_fees_btc.json
  def transaction_fees_btc
    @transaction_fees_btc = Charts::TransactionFeeBtc.all.map do |item| 
      [item['time'], item['total'].to_i]
    end 
  end
  
  # GET /charts/transaction_fees_usd
  # GET /charts/transaction_fees_usd.json
  def transaction_fees_usd
    @transaction_fees_usd = Charts::TransactionFeeUsd.all.map do |item| 
      [item['time'], item['total'].to_i]
    end 
  end
  
  # GET /charts/network_deficit
  # GET /charts/network_deficit.json
  def network_deficit
    @network_deficit  = Charts::NetworkDeficit.all.map do |item| 
      [item['time'], item['total'].to_i]
    end 
  end
  
  # GET /charts/transaction_daily
  # GET /charts/transaction_daily.json
  def transaction_daily
    @transaction_daily = Charts::TransactionDaily.all.map do |item| 
      [item['time'], item['total'].to_i]
    end 
  end
  
  # GET /charts/transaction_total
  # GET /charts/transaction_total.json
  def transaction_total
    @transaction_total = Charts::TransactionTotal.all.map do |item| 
      [item['time'], item['total'].to_i]
    end 
  end
  
  # GET /charts/unique_address
  # GET /charts/unique_address.json
  def unique_address
    @unique_address = Charts::UniqueAddress.all.map do |item| 
      [item['time'], item['total'].to_i]
    end 
  end
  
  # GET /charts/average_transaction
  # GET /charts/average_transaction.json
  def average_transaction 
    @average_transaction = Charts::AverageTransaction.all.map do |item| 
      [item['time'], item['total'].to_i]
    end 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_transaction
    #   @transaction = Transaction.find(params[:id])
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    def circulation_params
      params[:circulation]
    end
end
