class BlocksController < ApplicationController
  before_action :set_block, only: [:edit, :update, :destroy]

  # GET /blocks
  # GET /blocks.json
  def index
    @blocks = Block.all
  end

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

  # GET /blocks/new
  def new
    @block = Block.new
  end

  # GET /blocks/1/edit
  def edit
  end

  # POST /blocks
  # POST /blocks.json
  def create
    @block = Block.new(block_params)

    respond_to do |format|
      if @block.save
        format.html { redirect_to @block, notice: 'Block was successfully created.' }
        format.json { render :show, status: :created, location: @block }
      else
        format.html { render :new }
        format.json { render json: @block.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blocks/1
  # PATCH/PUT /blocks/1.json
  def update
    respond_to do |format|
      if @block.update(block_params)
        format.html { redirect_to @block, notice: 'Block was successfully updated.' }
        format.json { render :show, status: :ok, location: @block }
      else
        format.html { render :edit }
        format.json { render json: @block.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blocks/1
  # DELETE /blocks/1.json
  def destroy
    @block.destroy
    respond_to do |format|
      format.html { redirect_to blocks_url, notice: 'Block was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_block
      @block = Block.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def block_params
      params[:block]
    end
end
