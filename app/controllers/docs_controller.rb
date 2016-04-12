class DocsController < ApplicationController

  # GET /docs/developers
  def developers
    client = Octokit::Client.new access_token: Figaro.env.github_token

    @blockchain_bigearth_io = client.repo 'bigearth/blockchain.bigearth.io'
    @blockchain_bigearth_io_version = client.tags 'bigearth/blockchain.bigearth.io'
    @blockchain_bigearth_io_downloads = client.downloads 'bigearth/blockchain.bigearth.io'
    
    @chef_workstation_proxy = client.repo('bigearth/chef_workstation_proxy')
    @chef_workstation_proxy_version = client.tags 'bigearth/chef_workstation_proxy'
    
    @blockchain_proxy = client.repo('bigearth/blockchain_proxy')
    @blockchain_proxy_version = client.tags 'bigearth/blockchain_proxy'
  end
end
