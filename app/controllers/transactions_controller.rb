class TransactionsController < ApplicationController
  before_action :set_blockr, only: [:show, :raw]

  # GET /transactions/1
  # GET /transactions/1.json
  # GET /transactions/1,2,n.json
  def show 
    @tx = @blockr.transactions params[:id]
  end
  
  # GET /transactions/raw/1.json
  # GET /transactions/raw/1,2,n.json
  def raw
    @tx_raw = @blockr.transactions_raw params[:id]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blockr
      @blockr = BigEarth::Blockchain::Blockr.new
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    # def transaction_params
    #   params[:transaction]
    # end
end
