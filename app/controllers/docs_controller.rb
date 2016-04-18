class DocsController < ApplicationController

  # GET /docs/docs
  def docs
  end

  # GET /docs/developers
  def developers
    client = Octokit::Client.new access_token: Figaro.env.github_token

    #releases = client.releases 'bigearth/blockchain.bigearth.io'
    repos = client.repositories 'bigearth'
    @count = 0
    repos.each do |repo|
      @count += repo.forks_count
      @count += repo.watchers_count
      @count += repo.stargazers_count
    end
    @blockchain_bigearth_io = client.repo 'bigearth/blockchain.bigearth.io'
    @blockchain_bigearth_io_version = client.tags 'bigearth/blockchain.bigearth.io'
    
    @chef_workstation_proxy = client.repo('bigearth/chef_workstation_proxy')
    @chef_workstation_proxy_version = client.tags 'bigearth/chef_workstation_proxy'
    
    @blockchain_proxy = client.repo('bigearth/blockchain_proxy')
    @blockchain_proxy_version = client.tags 'bigearth/blockchain_proxy'
  end

  # GET /docs/api 
  def api
  end

  # GET /docs/security
  def security
  end
end
