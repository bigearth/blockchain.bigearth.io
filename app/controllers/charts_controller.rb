class ChartsController < ApplicationController
  # before_action :set_transaction, only: [:edit, :update, :destroy]

  # GET /charts/show
  # GET /charts/show.json
  def show 
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
  
  # GET /charts/transactions_daily
  # GET /charts/transactions_daily.json
  def transactions_daily
    @transactions_daily = Charts::TransactionDaily.all.map do |item| 
      [item['time'], item['total'].to_i]
    end 
  end
  
  # GET /charts/transactions_total
  # GET /charts/transactions_total.json
  def transactions_total
    @transactions_total = Charts::TransactionTotal.all.map do |item| 
      [item['time'], item['total'].to_i]
    end 
  end
  
  # GET /charts/unique_addresses
  # GET /charts/unique_addresses.json
  def unique_addresses
    @unique_addresses = Charts::UniqueAddress.all.map do |item| 
      [item['time'], item['total'].to_i]
    end 
  end
  
  # GET /charts/average_transactions
  # GET /charts/average_transactions.json
  def average_transactions 
    @average_transactions = Charts::AverageTransaction.all.map do |item| 
      [item['time'], item['total'].to_i]
    end 
  end
  
  # GET /charts/orphaned_blocks
  # GET /charts/orphaned_blocks.json
  def orphaned_blocks
    @orphaned_blocks = Charts::OrphanedBlock.all.map do |item| 
      [item['time'], item['total'].to_i]
    end 
  end
  
  # GET /charts/total_output
  # GET /charts/total_output.json
  def total_output
    @total_output = Charts::TotalOutput.all.map do |item| 
      [item['time'], item['total'].to_i]
    end 
  end
  
  # GET /charts/market_price
  # GET /charts/market_price.json
  def market_price
    @market_price = Charts::MarketPrice.all.map do |item| 
      [item['time'], item['total'].to_i]
    end 
  end
  
  # GET /charts/hash_rate
  # GET /charts/hash_rate.json
  def hash_rate
    @hash_rate = Charts::HashRate.all.map do |item| 
      [item['time'], item['total'].to_i]
    end 
  end
  
  # GET /charts/difficulty
  # GET /charts/difficulty.json
  def difficulty
    @difficulty = Charts::Difficulty.all.map do |item| 
      [item['time'], item['total'].to_i]
    end 
  end
  
  # GET /charts/days_destroyed_cumulative
  # GET /charts/days_destroyed_cumulative.json
  def days_destroyed_cumulative
    @days_destroyed_cumulative = Charts::DaysDestroyedCumulative.all.map do |item| 
      [item['time'], item['total'].to_i]
    end 
  end
  
  # GET /charts/days_destroyed
  # GET /charts/days_destroyed.json
  def days_destroyed
    @days_destroyed = Charts::DaysDestroyed.all.map do |item| 
      [item['time'], item['total'].to_i]
    end 
  end
  
  # GET /charts/blockchain_size
  # GET /charts/blockchain_size.json
  def blockchain_size
    @blockchain_size = Charts::BlockSize.all.map do |item| 
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
