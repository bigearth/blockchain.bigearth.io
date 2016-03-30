module BigEarth
  module Blockchain
    class ConfirmChefClientBootstrapped
      
      # Set queue
      @queue = "#{Rails.env}_confirm_chef_client_bootstrapped_worker"
      
      def self.perform title, ip_address_arr, flavor
        require 'httparty'
        begin
          HTTParty.get("#{Figaro.env.chef_workstation_ip_address}confirm_chef_client_bootstrapped", 
            basic_auth: {
              username: Figaro.env.chef_workstation_username, 
              password: Figaro.env.chef_workstation_password 
            },
            body: { 
              title: title, 
              ipv4_address: ip_address_arr.first,
              ipv6_address: ip_address_arr.last,
              flavor: flavor 
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
