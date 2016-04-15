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
    # Namespace the title by the user's email so that no global titles conflict
    @url = "#{format_title @chain.title, @user.email}.cloud.bigearth.io"
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
          email: @user.email,
          options: {
            flavor: @chain.flavor
          }
        }
        # Create node
        BigEarth::Blockchain::CreateNodeJob.perform_later config
        
        # Mask IP address behind DNS A record
        Resque.enqueue_in 15.seconds, BigEarth::Blockchain::CreateDNSRecord, config
        
        format.html { redirect_to [@user, @chain] }
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
      
      # Format config hash
      config = {
        type: 'blockchain',
        title: title,
        email: @user.email
      }
      
      # Queue up BigEarth::Blockchain::DestroyNodeJob
      BigEarth::Blockchain::DestroyNodeJob.perform_later config
      
      # Destroy the DNS A record
      BigEarth::Blockchain::DestroyDNSRecord.perform_later config
        
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
      # Namespace the title by the user's email so that no global titles conflict
      formatted_title = format_title params[:title], user.email
      
      @response = {
        status: 200,
        message: 'node created',
        url: "#{formatted_title}.cloud.bigearth.io"
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
  
  # blockchain
  
  def get_best_block_hash
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/get_best_block_hash.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
  
  def get_block
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/get_block.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      query: params['data'],
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
  
  def get_blockchain_info
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/get_blockchain_info.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
  
  def get_block_count
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/get_block_count.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
  
  def get_block_hash
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/get_block_hash.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      query: params['data'],
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
  
  def get_block_header
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/get_block_header.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      query: params['data'],
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
  
  def get_chain_tips
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/get_chain_tips.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
  
  def get_difficulty
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/get_difficulty.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
  
  def get_mem_pool_info
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/get_mem_pool_info.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
  
  def get_raw_mem_pool
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/get_raw_mem_pool.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
  
  def get_tx_out
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/get_tx_out.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
  
  def get_tx_out_proof
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/get_tx_out_proof.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
  
  def get_tx_outset_info
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/get_tx_outset_info.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
  
  def verify_chain
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/verify_chain.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
  
  def verify_tx_out_proof
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/verify_tx_out_proof.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
  
  # control
  
  def start
    require 'httparty'
    @response = HTTParty.post("http://#{params['url']}:8080/start.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
  
  def stop
    require 'httparty'
    @response = HTTParty.post("http://#{params['url']}:8080/stop.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
  
  def get_info
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/get_info.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: @response }
    end
  end
  
  # Generate
  def generate
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/generate.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
  
  def get_generate
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/get_generate.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
  
  def set_generate
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/set_generate.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
  
  # Mining
  def get_block_template
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/get_block_template.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
  
  def get_mining_info
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/get_mining_info.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
  
  def get_network_hashps
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/get_network_hashps.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
  
  def prioritise_transaction
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/prioritise_transaction.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
  
  def submit_block
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/submit_block.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
  
  # Network
  def add_node 
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/add_node.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
  
  def disconnect_node
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/disconnect_node.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
    
  def get_added_node_info
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/get_added_node_info.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
    
  def get_connection_count
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/get_connection_count.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
    
  def get_net_totals
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/get_net_totals.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
    
  def get_network_info
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/get_network_info.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
    
  def get_peer_info
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/get_peer_info.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
  
  def list_banned
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/list_banned.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
    
  def clear_banned
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/clear_banned.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
    
  def ping
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/ping.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
    
  def set_ban
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/set_ban.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
  
  # Transaction
  def create_raw_transaction  
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/create_raw_transaction.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
    
  def decode_raw_transaction 
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/decode_raw_transaction.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
    
  def decode_script
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/decode_script.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
      
  def get_raw_transaction  
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/get_raw_transaction.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
    
  def send_raw_transaction 
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/send_raw_transaction.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
    
  def sign_raw_transaction 
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/sign_raw_transaction.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
  
  # Util
  def create_multi_sig 
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/create_multi_sig.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
    
  def estimate_fee  
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/estimate_fee.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
  
  def estimate_priority  
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/estimate_priority.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
      
  def estimate_smart_fee  
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/estimate_smart_fee.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
  
  def estimate_smart_priority  
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/estimate_smart_priority.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
  
  def validate_address  
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/validate_address.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
    end
  end
  
  def verify_message  
    require 'httparty'
    @response = HTTParty.get("http://#{params['url']}:8080/verify_message.json", 
      basic_auth: {
        username: Figaro.env.blockchain_proxy_username, 
        password: Figaro.env.blockchain_proxy_password
      },
      headers: { 'Content-Type' => 'application/json' } 
    )
    respond_to do |format|
      format.json { render json: JSON.parse(@response) }
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
      params.require(:chain).permit :pub_key, :title, :flavor, :tier, :node_created, :ipv4_address, :ipv6_address, :user_id
    end
end
