module Blockchain
  module Node
    class ConfirmDropletCreatedJob < ActiveJob::Base
      queue_as :confirm_droplet_created_job
      
      def perform name
        begin
          client = DropletKit::Client.new access_token: Figaro.env.digital_ocean_api_token
          droplets = client.droplets.all
          droplet = droplets.select do |drplet|  
            drplet.name === name 
          end 
          
          node = Blockchain::Node.new
          
          if droplet.empty?
            node.delay(run_at: 1.minutes.from_now).confirm_droplet_created name 
          else
            ip_address = droplet.first['networks']['v4'].first['ip_address']
            existing_node = Chain.where('pub_key = ?', name).first
            existing_node.droplet_created = true
            existing_node.ip_address = ip_address
            existing_node.save
            flavor = existing_node.flavor
            
            # Bootstrap the chef Node
            node.bootstrap_chef_client name, ip_address, flavor
            node.delay(run_at: 1.minutes.from_now).confirm_client_bootstrapped name, ip_address, flavor
          end
          
        rescue Exception => error
          puts "confirm_droplet_created error: #{error}"
        end
      end
    end
  end
end
