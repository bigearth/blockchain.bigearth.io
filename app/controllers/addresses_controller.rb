class AddressesController < ApplicationController
  before_action :set_blockr, only: [:show, :balance, :unspent]

  # GET /addresses/1
  # GET /addresses/1.json
  # GET /addresses/1,2,n.json
  def show
    @address = @blockr.addresses params[:id]
    @txs  = @blockr.addresses_txs params[:id]
  end
  
  # GET /addresses/balance/1.json
  # GET /addresses/balance/1,2,n.json
  def balance
    @balance  = @blockr.addresses_balance params[:id]
  end
  
  # GET /addresses/unspent/1.json
  # GET /addresses/unspent/1,2,n.json
  def unspent 
    @unspent = @blockr.addresses_unspent params[:id]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blockr
      @blockr = BigEarth::Blockchain::Blockr.new
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    # def address_params
    #   params[:address]
    # end
end
