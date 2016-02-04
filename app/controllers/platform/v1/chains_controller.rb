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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_platform_v1_chain
      @platform_v1_chain = Platform::V1::Chain.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def platform_v1_chain_params
      params.require(:platform_v1_chain).permit(:pub_key)
    end
end
