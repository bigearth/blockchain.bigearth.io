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
        # Send an email to the user
        BigEarth::Blockchain::ChainCreatedEmailJob.perform_later @user, @chain
        
        # format data 
        config = {
          type: 'blockchain',
          title: @chain.title,
          options: {
            email: @user.email,
            flavor: @chain.flavor
          }
        }
        # Create node
        BigEarth::Blockchain::CreateNodeJob.perform_later config
        
        format.html { redirect_to [@user, @chain], notice: "Chain '#{@chain.title}' is being created." }
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
      title = @chain.title
      
      # Queue up BigEarth::Blockchain::DestroyNodeJob
      BigEarth::Blockchain::DestroyNodeJob.perform_later title, @user.email
        
      # Send an email to the user
      BigEarth::Blockchain::ChainDestroyedEmailJob.perform_later @user, title
      
      # Delete the chain from DB
      @chain.destroy
    rescue => error
      puts "[ERROR] #{Time.now}: #{error.class}: #{error.message}"
    end
    respond_to do |format|
      format.html { redirect_to @user, notice: "Chain '#{title}' was successfully destroyed." }
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
