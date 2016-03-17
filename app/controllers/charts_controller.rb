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
      [item['time'], item['total']]
    end 
  end

  # GET /charts/market_cap
  # GET /charts/market_cap.json
  def market_cap
    @market_cap = Charts::MarketCap.all.map do |item| 
      [item['time'], item['total']]
    end 
  end

  # GET /charts/transaction_fees_btc
  # GET /charts/transaction_fees_btc.json
  def transaction_fees_btc
    @transaction_fees_btc = Charts::TransactionFeeBtc.all.map do |item| 
      [item['time'], item['total']]
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
