module Blockchain
  class Node
    def confirm_droplet_created name
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
  
    def bootstrap_chef_client name, ip_address, flavor
      require 'httparty'
      begin
        HTTParty.post("#{Figaro.env.chef_workstation_ip_address}bootstrap_chef_client", 
          basic_auth: {
            username: Figaro.env.chef_workstation_username, 
            password: Figaro.env.chef_workstation_password 
          },
          body: { 
            name: name, 
            ip_address: ip_address,
            flavor: flavor 
          }.to_json,
          headers: { 'Content-Type' => 'application/json' } 
        )
      rescue Exception => error
          puts "bootstrap_chef_client error: #{error}"
      end
    end
  
    def confirm_client_bootstrapped name, ip_address, flavor
      require 'httparty'
      begin
        HTTParty.get("#{Figaro.env.chef_workstation_ip_address}confirm_client_bootstrapped", 
          basic_auth: {
            username: Figaro.env.chef_workstation_username, 
            password: Figaro.env.chef_workstation_password 
          },
          body: { 
            name: name, 
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
