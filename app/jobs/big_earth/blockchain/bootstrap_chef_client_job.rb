module BigEarth
  module Blockchain
    class BootstrapChefClientJob < ActiveJob::Base
      queue_as :bootstrap_chef_client_job
      
      def perform title, ip_address_arr, flavor
        require 'httparty'
        begin
          HTTParty.post("#{Figaro.env.chef_workstation_ip_address}bootstrap_chef_client", 
            basic_auth: {
              username: Figaro.env.chef_workstation_username, 
              password: Figaro.env.chef_workstation_password 
            },
            body: { 
              title: title, 
              ipv4_address: ip_address_arr.first,
              ipv6_address: ip_address_arr.last,
              flavor: flavor 
              # TODO instead of 'flavor' pass over an options hash w/ type and optionally flavor.
              # Then on the other side parse the type and bootstrap chef-workstations, chef-servers and/or bitcoin nodes
            }.to_json,
            headers: { 'Content-Type' => 'application/json' } 
          )
        rescue => error
            puts "bootstrap_chef_client error: #{error}"
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
