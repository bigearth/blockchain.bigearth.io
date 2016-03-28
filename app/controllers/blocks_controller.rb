class BlocksController < ApplicationController
  #before_action :set_block, only: [:edit, :update, :destroy]

  # GET /blocks/1
  # GET /blocks/1.json
  # GET /blocks/1,2,n.json
  # GET /blocks/first.json
  # GET /blocks/last.json
  def show
    # TODO: Wrap these calls in ActiveModel::Model classes to enable testing
    # * More info: http://devdocs.io/rails/activemodel/model
    # TODO: Consider data warehousing this or how to store blockchain data relationally
    blockr = BigEarth::Blockchain::Blockr.new
    @block = blockr.block params[:id]
    @txs = blockr.block_txs params[:id]
  end
  
  # GET /blocks/transactions/1.json
  # GET /blocks/transactions/1,2,n.json
  # GET /blocks/transactions/first.json
  # GET /blocks/transactions/last.json
  def transactions
    blockr = BigEarth::Blockchain::Blockr.new
    @txs = blockr.block_txs params[:id]
  end
  
  # GET /blocks/raw/1.json
  # GET /blocks/raw/1,2,n.json
  # GET /blocks/raw/first.json
  # GET /blocks/raw/last.json
  def raw
    blockr = BigEarth::Blockchain::Blockr.new
    @raw_txs = blockr.block_raw params[:id]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_block
    #   @block = Block.find(params[:id])
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    def block_params
      params[:block]
    end
end
