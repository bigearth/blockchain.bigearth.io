class Platform::V1::ChainsController < ApplicationController
  before_action :set_platform_v1_chain, only: [:show, :edit, :update, :destroy]
  http_basic_authenticate_with name: Figaro.env.http_basic_auth_name, password: Figaro.env.http_basic_auth_password

  # GET /platform/v1/chains
  # GET /platform/v1/chains.json
  def index
    @platform_v1_chains = Platform::V1::Chain.all
  end

  # GET /platform/v1/chains/1
  # GET /platform/v1/chains/1.json
  def show
  end

  # GET /platform/v1/chains/new
  def new
    @platform_v1_chain = Platform::V1::Chain.new
  end

  # GET /platform/v1/chains/1/edit
  def edit
  end

  # POST /platform/v1/chains
  # POST /platform/v1/chains.json
  def create
    @platform_v1_chain = Platform::V1::Chain.new(platform_v1_chain_params)

    respond_to do |format|
      if @platform_v1_chain.save
        format.html { redirect_to @platform_v1_chain, notice: 'Chain was successfully created.' }
        format.json { render :show, status: :created, location: @platform_v1_chain }
      else
        format.html { render :new }
        format.json { render json: @platform_v1_chain.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /platform/v1/chains/1
  # PATCH/PUT /platform/v1/chains/1.json
  def update
    respond_to do |format|
      if @platform_v1_chain.update(platform_v1_chain_params)
        format.html { redirect_to @platform_v1_chain, notice: 'Chain was successfully updated.' }
        format.json { render :show, status: :ok, location: @platform_v1_chain }
      else
        format.html { render :edit }
        format.json { render json: @platform_v1_chain.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /platform/v1/chains/1
  # DELETE /platform/v1/chains/1.json
  def destroy
    @platform_v1_chain.destroy
    respond_to do |format|
      format.html { redirect_to platform_v1_chains_url, notice: 'Chain was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /platform/v1/chains/get_chain
  def get_chain
    
    # Wrap webservice calls in begin/rescue block
    begin
      @client = DropletKit::Client.new access_token: Figaro.env.digital_ocean_api_token
      droplets = @client.droplets.all
      @droplet = droplets.select do |droplet|  
        droplet.name === params[:name] 
      end 
      
      if @droplet.empty?
        @response = {
          status: 'does_not_exist'
        }
      else
        @response = @droplet
      end
      
    rescue Exception => error
      @response = {
        status: 500,
        message: 'Error'
      }
    end
    respond_to do |format|
      format.json { render json: @response }
    end
  end
  
  # POST /platform/v1/chains/new_chain
  def new_chain
    # Wrap in begin/rescue block
    begin
      
      # Get the Digital Ocean Client
      @client = DropletKit::Client.new access_token: Figaro.env.digital_ocean_api_token
      
      # select just the appropriate droplet
      droplet = @client.droplets.all.select do |droplet|  
        droplet.name === params[:name] 
      end 
      
      if droplet.empty?
        
        # If droplet doesn't exist then create it
        # Hardcoded values for now. Will likely change that in the future as the dashboard becomes more fully featured
        new_droplet = DropletKit::Droplet.new({
          name: params[:name], 
          region: 'sfo1', 
          size: '8gb', 
          ssh_keys: [
            Figaro.env.ssh_key_id
          ],
          image: 'ubuntu-14-04-x64', 
          ipv6: true
        })
        
        # Create it
        @response = @client.droplets.create new_droplet
          
        # Update Active Record w/ Blockchain flavor
        existing_node = Platform::V1::Chain.where('pub_key = ?', params[:name]).first
        existing_node.blockchain_flavor = params[:flavor]
        existing_node.save
        
        # Confirm that the droplet got created in 2 minutes
        require 'blockchain'
        node = Blockchain::Node.new
        node.delay(run_at: 1.minutes.from_now).confirm_droplet_created params[:name] 
      else
        @response = {
          status: 'already_exists'
        }
      end
    rescue Exception => error
      @response = {
        status: 500,
        message: 'Error'
      }
    end
    
    respond_to do |format|
      format.json { render json: @response }
    end
  end
    
  # DELETE /platform/v1/chains/delete_chain
  def destroy_chain
    # Wrap in begin/rescue block
    begin
      
      # Get the Digital Ocean Client
      @client = DropletKit::Client.new access_token: Figaro.env.digital_ocean_api_token
      
      # Get all the droplets 
      droplets = @client.droplets.all
      
      # Select just the appropriate droplet
      @droplet = droplets.select do |droplet|  
        droplet.name === params[:name] 
      end 
      
      if !@droplet.empty?
        # IF the droplet exists then delete it
        @client.droplets.delete id: @droplet.first['id']
        
        # Return deleted status
        @response = {
          status: 200,
          status_message: 'deleted'
        }
        
      else
        
        # The droplet doesn't exists
        @response = {
          status: 200,
          status_message: 'nothing_to_delete'
        }
        
      end
    rescue Exception => error
      
      # Handle errors
      @response = {
        status: 500,
        status_message: error
      }
      
    end
    
    respond_to do |format|
      format.json { render json: @response}
    end
  end
    
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_platform_v1_chain
      @platform_v1_chain = Platform::V1::Chain.find params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def platform_v1_chain_params
      params.require(:platform_v1_chain).permit(:pub_key)
    end
end
