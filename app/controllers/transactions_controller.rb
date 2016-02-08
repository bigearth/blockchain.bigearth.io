class TransactionsController < ApplicationController
  # before_action :set_transaction, only: [:edit, :update, :destroy]

  # GET /transactions/1
  # GET /transactions/1.json
  # GET /transactions/1,2,n.json
  def show 
    @tx = HTTParty.get "http://btc.blockr.io/api/v1/tx/info/#{params[:id]}" 
  end
  
  # GET /transactions/raw/1.json
  # GET /transactions/raw/1,2,n.json
  def raw
    @raw_tx = HTTParty.get "http://btc.blockr.io/api/v1/tx/raw/#{params[:id]}" 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_transaction
    #   @transaction = Transaction.find(params[:id])
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transaction_params
      params[:transaction]
    end
end
