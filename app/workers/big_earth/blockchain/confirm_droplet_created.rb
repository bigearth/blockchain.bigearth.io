module BigEarth
  module Blockchain
    class ConfirmDropletCreated
      
      # Set queue
      @queue = :confirm_droplet_created_job
      
      def self.perform formatted_title, title
        # Wrap in begin/rescue block
        begin
          
          # Get the Digital Ocean Client
          client = DropletKit::Client.new access_token: Figaro.env.digital_ocean_api_token
          
          # select just the appropriate droplet
          droplet = client.droplets.all.select do |drplet|  
            drplet.name === formatted_title 
          end 
          
          if droplet.empty?
            # run in 1 minute
            Resque.enqueue_in(1.minutes, BigEarth::Blockchain::ConfirmDropletCreated, formatted_title, title)
          else
            ipv4_address = droplet.first['networks']['v4'].first['ip_address']
            ipv6_address = droplet.first['networks']['v6'].first['ip_address']
            existing_node = Chain.where('title = ?', title).first
            existing_node.droplet_created = true
            existing_node.ipv4_address = ipv4_address
            existing_node.ipv6_address = ipv6_address
            existing_node.save
            flavor = existing_node.flavor
            
            # Bootstrap the chef Node
            BigEarth::Blockchain::BootstrapChefClientJob.perform_later title, [ipv4_address, ipv6_address], flavor
            # run in 1 minute
            Resque.enqueue_in(1.minutes, BigEarth::Blockchain::ConfirmClientBootstrapped, title,  [ipv4_address, ipv6_address], flavor)
          end
          
        rescue => error
          puts "confirm_droplet_created error: #{error}"
        end
      end
    end
  end
end
