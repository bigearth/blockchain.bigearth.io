module BigEarth
  module Blockchain
    class ConfirmClientBootstrapped < ActiveJob::Base
      queue_as :confirm_client_bootstrapped
      
      def perform title, ip_address, flavor
        require 'httparty'
        begin
          HTTParty.get("#{Figaro.env.chef_workstation_ip_address}confirm_client_bootstrapped", 
            basic_auth: {
              username: Figaro.env.chef_workstation_username, 
              password: Figaro.env.chef_workstation_password 
            },
            body: { 
              title: title, 
              ip_address: ip_address,
              flavor: flavor 
            }.to_json,
            headers: { 'Content-Type' => 'application/json' } 
          )
        rescue Exception => error
            puts "bootstrap_chef_client error: #{error}"
        end
      end
    end
  end
end
