class BlocksController < ApplicationController
  before_action :set_blockr, only: [:show, :transactions, :raw]

  # GET /blocks/1
  # GET /blocks/1.json
  # GET /blocks/1,2,n.json
  # GET /blocks/first.json
  # GET /blocks/last.json
  def show
    # TODO: Consider data warehousing this or how to store blockchain data relationally
    @block = @blockr.blocks params[:id]
    @txs = @blockr.blocks_txs params[:id]
  end
  
  # GET /blocks/transactions/1.json
  # GET /blocks/transactions/1,2,n.json
  # GET /blocks/transactions/first.json
  # GET /blocks/transactions/last.json
  def transactions
    @txs = @blockr.blocks_txs params[:id]
  end
  
  # GET /blocks/raw/1.json
  # GET /blocks/raw/1,2,n.json
  # GET /blocks/raw/first.json
  # GET /blocks/raw/last.json
  def raw
    @blocks_raw = @blockr.blocks_raw params[:id]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blockr
      @blockr = BigEarth::Blockchain::Blockr.new
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    # def block_params
    #   params[:block]
    # end
end
