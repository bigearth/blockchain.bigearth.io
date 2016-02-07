class AddressesController < ApplicationController
  before_action :set_address, only: [:edit, :update, :destroy]

  # GET /addresses/1
  # GET /addresses/1.json
  # GET /addresses/1,2,n.json
  def show
    @address = HTTParty.get "http://btc.blockr.io/api/v1/address/info/#{params[:id]}"
    @txs = HTTParty.get "http://btc.blockr.io/api/v1/address/txs/#{params[:id]}"
  end
  
  # GET /addresses/balance/1.json
  # GET /addresses/balance/1,2,n.json
  def balance
    @balance = HTTParty.get "http://btc.blockr.io/api/v1/address/balance/#{params[:id]}"
  end
  
  # GET /addresses/unspent/1.json
  # GET /addresses/unspent/1,2,n.json
  def unspent 
    @unspent = HTTParty.get "http://btc.blockr.io/api/v1/address/unspent/#{params[:id]}"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_address
    #   @address = Address.find(params[:id])
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    def address_params
      params[:address]
    end
end
