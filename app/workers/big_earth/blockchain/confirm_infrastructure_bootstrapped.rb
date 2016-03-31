module BigEarth
  module Blockchain
    class ConfirmInfrastructureBootstrapped
      
      # Set queue
      @queue = "#{Rails.env}_confirm_infrastructure_bootstrapped_worker"
      
      def self.perform config
        require 'httparty'
        begin
          HTTParty.get("#{Figaro.env.chef_workstation_ip_address}confirm_infrastructure_bootstrapped", 
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
