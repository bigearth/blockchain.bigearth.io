class ExplorersController < ApplicationController
  before_action :set_explorer, only: [:show, :edit, :update, :destroy]

  # GET /explorers
  # GET /explorers.json
  def index
    @coin_info = HTTParty.get 'http://btc.blockr.io/api/v1/coin/info' 
    block_height = @coin_info['data']['last_block']['nb']
    blocks = ((block_height - 10)..block_height).to_a.reverse
    @blocks = HTTParty.get "http://btc.blockr.io/api/v1/block/info/#{blocks.join(',')}"
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
