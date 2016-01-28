class ExplorersController < ApplicationController
  before_action :set_explorer, only: [:show, :edit, :update, :destroy]

  # GET /explorers
  # GET /explorers.json
  def index
    # Fetch Coin Info from external webservice
    @coin_info = HTTParty.get 'http://btc.blockr.io/api/v1/coin/info' 
    
    # Clean up data which we don't want to display in our JSON results
    @coin_info['data'].delete 'websocket'
    @coin_info['data']['coin'].delete 'logo'
    @coin_info['data']['coin'].delete 'homepage'
    
    # Get the block height
    block_height = @coin_info['data']['last_block']['nb']
    
    # Calculate number_of_blocks based on the presence and value or absence of the ?prev_block_count param
    if params[:prev_block_count].nil? || params[:prev_block_count] === ""
      # If there is no prev_block_count param then default to 20 previous blocks 
      number_of_blocks = 20
    elsif params[:prev_block_count].to_i < 2
      # if prev_block_count is less than to default to 2 previous blocks
      number_of_blocks = 2
    elsif params[:prev_block_count].to_i > 20
      # prev_block_count is more than 20 default to 20 previous blocks
      number_of_blocks = 20
    else
      # in all other cases go w/ the user's input
      number_of_blocks = params[:prev_block_count].to_i
    end
    
    # Calculate earlier_block_height based on presence/absence of ?prev_block_count param
    @earlier_block_height = block_height - number_of_blocks
    
    # Create array of block heights and pop out the last one so that the count matches ?prev_block_count
    prev_blocks = (@earlier_block_height..block_height).to_a.reverse
    prev_blocks.pop

    # color code the next difficulty change
    if @coin_info['data']['next_difficulty']['perc'] >= 0
      @change_level = 'success'
    else
      @change_level = 'danger'
    end
    
    # Fetch Block Info from external webservice 
    @blocks = HTTParty.get "http://btc.blockr.io/api/v1/block/info/#{prev_blocks.join(',')}"
    
    @statistics = {
      nb_txs: [],
      fee: [],
      size: [],
      days_destroyed: []
    }
    @blocks['data'].each do |item|
      @statistics[:nb_txs] << item['nb_txs'].to_i
      @statistics[:fee] << item['fee'].to_f
      @statistics[:size] << item['size'].to_i
      @statistics[:days_destroyed] << item['days_destroyed'].to_f
    end
  end

  # GET /explorers/1
  # GET /explorers/1.json
  def show
  end

  # GET /explorers/new
  def new
    @explorer = Explorer.new
  end

  # GET /explorers/1/edit
  def edit
  end

  # POST /explorers
  # POST /explorers.json
  def create
    @explorer = Explorer.new(explorer_params)

    respond_to do |format|
      if @explorer.save
        format.html { redirect_to @explorer, notice: 'Explorer was successfully created.' }
        format.json { render :show, status: :created, location: @explorer }
      else
        format.html { render :new }
        format.json { render json: @explorer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /explorers/1
  # PATCH/PUT /explorers/1.json
  def update
    respond_to do |format|
      if @explorer.update(explorer_params)
        format.html { redirect_to @explorer, notice: 'Explorer was successfully updated.' }
        format.json { render :show, status: :ok, location: @explorer }
      else
        format.html { render :edit }
        format.json { render json: @explorer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /explorers/1
  # DELETE /explorers/1.json
  def destroy
    @explorer.destroy
    respond_to do |format|
      format.html { redirect_to explorers_url, notice: 'Explorer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  # GET /bookmarks
  def bookmarks
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_explorer
      @explorer = Explorer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def explorer_params
      params[:explorer]
    end
end
