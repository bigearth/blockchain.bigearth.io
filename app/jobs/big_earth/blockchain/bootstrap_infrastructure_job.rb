module BigEarth
  module Blockchain
    class BootstrapInfrastructureJob < ActiveJob::Base
      queue_as :bootstrap_infrastructure_job
      
      def perform config
        require 'httparty'
        begin
          HTTParty.post("#{Figaro.env.chef_workstation_ip_address}bootstrap_infrastructure", 
            basic_auth: {
              username: Figaro.env.chef_workstation_username, 
              password: Figaro.env.chef_workstation_password 
            },
            body: { 
              config: config
            }.to_json,
            headers: { 'Content-Type' => 'application/json' } 
          )
        rescue => error
          puts "[ERROR] #{Time.now}: #{error.class}: #{error.message}"
        end
      end
    end
  end
end

# TODO: Day Dreaming...
# 1. Vagrant script which bootstraps local dev environment.
#  * Sets up dev environment
#  * Creates heroku user and application
# 2. Additionally or independently use existing chef-server and chef-workstation to bootstrap additional chef-server/workstation(s) 
#  * Run a rake task from the rails app which passes over the type (in this job) of node to bootstrap
#  * It will be nice to have failsafes and redundancy in this way 
