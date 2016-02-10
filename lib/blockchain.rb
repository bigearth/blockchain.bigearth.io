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
          existing_node = Platform::V1::Chain.where('pub_key = ?', name).first
          existing_node.droplet_created = true
          existing_node.ip_address = ip_address
          existing_node.save
          node.bootstrap_chef_node name, ip_address
        end
        
      rescue Exception => error
        puts "confirm_droplet_created error: #{error}"
      end
    end
  
    def bootstrap_chef_node name, ip_address
      require 'httparty'
      begin
        HTTParty.post("#{Figaro.env.chef_workstation_ip_address}bootstrap_chef_node", 
          basic_auth: {
            username: Figaro.env.chef_workstation_username, 
            password: Figaro.env.chef_workstation_password 
          },
          body: { 
            name: name, 
            ip_address: ip_address 
          }.to_json,
          headers: { 'Content-Type' => 'application/json' } 
        )
        node = Blockchain::Node.new
        node.delay(run_at: 1.minutes.from_now).confirm_chef_node_bootstraped name, ip_address
      rescue Exception => error
          puts "bootstrap_chef_node error: #{error}"
      end
    end
    
    def confirm_chef_node_bootstraped name, ip_address
      require 'httparty'
      begin
        puts 'good job mates'
      rescue Exception => error
          puts "confirm_chef_node_bootstraped error: #{error}"
      end
    end
  end
end
