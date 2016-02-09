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
    @client = DropletKit::Client.new access_token: Figaro.env.digital_ocean_api_token
    droplet = @client.droplets.all.select do |droplet|  
      droplet.name === params[:name] 
    end 
    
    if droplet.empty?
      new_droplet = DropletKit::Droplet.new({
        name: params[:name], 
        region: 'sfo1', 
        size: '512mb', 
        ssh_keys: [
          Figaro.env.ssh_key_id
        ],
        image: 'ubuntu-14-04-x64', 
        ipv6: true
      })
      @response = @client.droplets.create new_droplet
      Resque.enqueue(ConfirmNodeCreated, params[:name])
    else
      @response = {
        status: 'already_exists'
      }
    end
    
    respond_to do |format|
      format.json { render json: @response }
    end
  end
    
  # DELETE /platform/v1/chains/delete_chain
  def destroy_chain
    @client = DropletKit::Client.new access_token: Figaro.env.digital_ocean_api_token
    droplets = @client.droplets.all
    @droplet = droplets.select do |droplet|  
      droplet.name === params[:name] 
    end 
    
    if !@droplet.empty?
      @client.droplets.delete id: @droplet.first['id']
      @response = {
        status: 'deleted'
      }
    else
      @response = {
        status: 'nothing_to_delete'
      }
    end
    
    respond_to do |format|
      format.json { render json: @response}
    end
  end
    
  # GET /platform/v1/chains/harden_chain
  def harden_chain
    # puts `ssh -o "StrictHostKeyChecking no" root@#{Figaro.env.droplet_ip_address} 'sudo apt-get update && apt-get -y upgrade && apt-get -y install tmux vim tree ack-grep ntp git build-essential libssl-dev libdb-dev libdb++-dev libboost-all-dev libqrencode-dev htop bundler zsh git-core tig autoconf pkg-config makepasswd transmission-common transmission-daemon transmission-remote-cli build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev && git clone https://github.com/bitcoinxt/bitcoinxt.git'`
    puts `ssh -o "StrictHostKeyChecking no" root@#{Figaro.env.droplet_ip_address} 'sudo apt-get update && apt-get -y upgrade && apt-get -y install tmux vim tree ack-grep ntp git build-essential libssl-dev libdb-dev libdb++-dev libboost-all-dev libqrencode-dev htop bundler zsh git-core tig autoconf pkg-config makepasswd transmission-common transmission-daemon transmission-remote-cli build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev &&  wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh && add-apt-repository -y ppa:bitcoin/bitcoin && apt-get update && apt-get -y install libdb4.8-dev libdb4.8++-dev libminiupnpc-dev libzmq3-dev libcurl4-openssl-dev zlib1g-dev && git clone https://github.com/bitcoinxt/bitcoinxt.git'`
  end
    
  # GET /platform/v1/chains/list_ssh_keys
  def list_ssh_keys
    client = DropletKit::Client.new access_token: Figaro.env.digital_ocean_api_token
    @ssh_keys = client.ssh_keys.all()
    respond_to do |format|
      format.json { render json: @ssh_keys}
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
