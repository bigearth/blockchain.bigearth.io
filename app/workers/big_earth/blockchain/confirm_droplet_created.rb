module BigEarth
  module Blockchain
    class ConfirmDropletCreated
      extend BigEarth::Blockchain::Utility
      
      # Set queue
      @queue = :confirm_droplet_created_job
      
      def self.perform title, email
        # Wrap in begin/rescue block
        begin
          
          # Get the Digital Ocean Client
          digital_ocean_client = DropletKit::Client.new access_token: Figaro.env.digital_ocean_api_token
          
          # Namespace the title by the user's email so that no global titles conflict
          formatted_title = format_title title, email
          
          # select just the appropriate droplet
          droplet = fetch_droplet digital_ocean_client, formatted_title 
          
          if droplet.empty?
            # run in 1 minute
            Resque.enqueue_in(1.minutes, BigEarth::Blockchain::ConfirmDropletCreated, title)
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
          
        # rescue BigEarth::Blockchain::Exceptions::ConfirmDropletCreatedException => error
        rescue => error
          puts "[ERROR] #{Time.now}: #{error.class}: #{error.message}"
        end
      end
    end
  end
end
