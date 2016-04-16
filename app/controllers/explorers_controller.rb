class ExplorersController < ApplicationController
  #before_action :set_explorer, only: [:show, :edit, :update, :destroy]
  http_basic_authenticate_with name: Figaro.env.cloud_username, password: Figaro.env.cloud_password, only: :cloud

  # GET /explorers
  # GET /explorers.json
  def index
    # Fetch Coin Info from external webservice
    blockr = BigEarth::Blockchain::Blockr.new
    @coin_info = blockr.coin
    
    # Clean up data which we don't want to display in our JSON results
    @coin_info['data'].delete 'websocket'
    @coin_info['data']['coin'].delete 'logo'
    @coin_info['data']['coin'].delete 'homepage'
    
    # Get the block height
    block_height = @coin_info['data']['last_block']['nb']
    
    # Calculate number_of_blocks based on the presence and value or absence of the ?prev_block_count param
    if params[:prev_block_count].nil? || params[:prev_block_count] == ""
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
    @blocks = blockr.blocks prev_blocks.join(',')
  end
  
  def search
    url = block_url params['search'] 
    resp = HTTParty.get "#{url}.json"
    if resp['data'].nil?
      url = transaction_url params['search'] 
      resp = HTTParty.get "#{url}.json"
    end
    if resp['data'].nil?
      url = address_url params['search'] 
      resp = HTTParty.get "#{url}.json"
    end
    respond_to do |format|
      if resp['data'].nil? || resp['data']['is_unknown'] == true
        format.html { redirect_to root_url, notice: "'#{params['search']}' doesn't appear to be a valid search. Try again." }
        format.json { render json: @chain.errors, status: :unprocessable_entity }
      else
        format.html { redirect_to "#{url}" }
        format.json { redirect_to "#{url}.json" }
      end
    end
  end
  
  def cloud
    # Get the Digital Ocean Client
    digital_ocean_client = DropletKit::Client.new access_token: Figaro.env.digital_ocean_api_token
    
    # Get all of the droplets
    @droplets = digital_ocean_client.droplets.all
  end
  
  def letsencrypt
    render text: Figaro.env.lets_encrypt_key
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_explorer
    #   @explorer = Explorer.find(params[:id])
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    def explorer_params
      params[:explorer]
    end
end
