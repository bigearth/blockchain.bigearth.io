class ChainsController < ApplicationController
  before_action :set_chain, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  include BigEarth::Blockchain::Utility

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
        BigEarth::Blockchain::CreateNodeJob.perform_later @user, @chain
        format.html { redirect_to [@user, @chain], notice: 'Chain is being created.' }
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
    
    # Wrap in begin/rescue block
    begin
      # Get the Digital Ocean Client
      digital_ocean_client = DropletKit::Client.new access_token: Figaro.env.digital_ocean_api_token
      
      # get User
      user = User.find params[:user_id]
      
      chain = user.chains.find params[:id]
      
      # Namespace the title by the user's email so that no global titles conflict
      formatted_title = format_title chain.title, user.email
          
      # select just the appropriate node
      node = fetch_node digital_ocean_client, formatted_title 
      
      unless node.empty?
        # IF the node exists then delete it
        digital_ocean_client.droplets.delete id: node.first['id']
      end
      
      # Delete the chain from DB
      @chain.destroy
    rescue => error
      puts "[ERROR] #{Time.now}: #{error.class}: #{error.message}"
    end
    respond_to do |format|
      format.html { redirect_to @user, notice: 'Chain was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /users/1/chains/confirm_node_created
  def confirm_node_created
    
    user = User.find params[:user_id]
    chain = user.chains.where('title = ?', params[:title]).first
    if chain.node_created
      @response = {
        status: 200,
        message: 'node created',
        ipv4_address: chain.ipv4_address,
        ipv6_address: chain.ipv6_address
      }
    else
      @response = {
        status: 200,
        message: 'node not created'
      }
    end
    respond_to do |format|
      format.json { render json: @response }
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
      params.require(:chain).permit :pub_key, :title, :flavor, :node_created, :ipv4_address, :ipv6_address, :user_id
    end
end
