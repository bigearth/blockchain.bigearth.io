class ChainsController < ApplicationController
  before_action :set_chain, only: [:show, :edit, :update, :destroy]

  # GET /users/1/chains
  # GET /users/1/chains.json
  def index
    @chains = Chain.all
  end

  # GET /users/1/chains/1
  # GET /users/1/chains/1.json
  def show
  end

  # GET /users/1/chains/new
  def new
    @user = User.find params[:user_id]
    @chain = @user.chains.new
  end

  # GET /users/1/chains/edit
  def edit
  end

  # POST /users/1chains
  # POST /users/1chains.json
  def create
    @user = User.find params[:user_id]
    @chain = @user.chains.new chain_params

    respond_to do |format|
      if @chain.save 
        CreateChainJob.perform_later @chain
        format.html { redirect_to [@user, @chain], notice: 'Chain was successfully created.' }
        format.json { render :show, status: :created, location: @chain }
      else
        format.html { render :new }
        format.json { render json: @chain.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1/chains/1
  # PATCH/PUT /users/1/chains/1.json
  def update
    respond_to do |format|
      if @chain.update(chain_params)
        format.html { redirect_to @chain, notice: 'Chain was successfully updated.' }
        format.json { render :show, status: :ok, location: @chain }
      else
        format.html { render :edit }
        format.json { render json: @chain.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1/chains/1
  # DELETE /users/1/chains/1.json
  def destroy
    @chain.destroy
    respond_to do |format|
      format.html { redirect_to chains_url, notice: 'Chain was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /users/1/chains/confirm_droplet_created
  def confirm_droplet_created
    
    chain = Chain.find params[:id]
    if chain.droplet_created
      @response = {
        status: 200,
        message: 'droplet created',
        ip_address: chain.ip_address
      }
    else
      @response = {
        status: 200,
        message: 'droplet not created'
      }
    end
    respond_to do |format|
      format.json { render json: @response }
    end
  end
    
  # DELETE /users/1/chains/delete_chain
  def destroy_chain
    # Wrap in begin/rescue block
    begin
      
      # Get the Digital Ocean Client
      @client = DropletKit::Client.new access_token: Figaro.env.digital_ocean_api_token
      
      # Get all the droplets 
      droplets = @client.droplets.all
      
      # Select just the appropriate droplet
      @droplet = droplets.select do |droplet|  
        droplet.name == params[:name] 
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
    def set_chain
      @user = User.find params[:user_id]
      @chain = @user.chains.find params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chain_params
      params.require(:chain).permit :pub_key, :title, :flavor, :droplet_created, :ip_address, :user_id
    end
end
