class BlocksController < ApplicationController
  #before_action :set_block, only: [:edit, :update, :destroy]

  # GET /blocks/1
  # GET /blocks/1.json
  # GET /blocks/1,2,n.json
  # GET /blocks/first.json
  # GET /blocks/last.json
  def show
    @block = HTTParty.get "http://btc.blockr.io/api/v1/block/info/#{params[:id]}" 
    @txs = HTTParty.get "http://btc.blockr.io/api/v1/block/txs/#{params[:id]}" 
  end
  
  # GET /blocks/transactions/1.json
  # GET /blocks/transactions/1,2,n.json
  # GET /blocks/transactions/first.json
  # GET /blocks/transactions/last.json
  def transactions
    @txs = HTTParty.get "http://btc.blockr.io/api/v1/block/txs/#{params[:id]}" 
  end
  
  # GET /blocks/raw/1.json
  # GET /blocks/raw/1,2,n.json
  # GET /blocks/raw/first.json
  # GET /blocks/raw/last.json
  def raw
    @raw_txs = HTTParty.get "http://btc.blockr.io/api/v1/block/raw/#{params[:id]}" 
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
