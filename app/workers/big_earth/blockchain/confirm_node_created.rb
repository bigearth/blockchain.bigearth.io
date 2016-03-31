module BigEarth
  module Blockchain
    class ConfirmNodeCreated
      extend BigEarth::Blockchain::Utility
      
      # Set queue
      @queue = "#{Rails.env}_confirm_node_created_worker"
      
      def self.perform title, email
        # Wrap in begin/rescue block
        begin
          
          # Get the Digital Ocean Client
          digital_ocean_client = DropletKit::Client.new access_token: Figaro.env.digital_ocean_api_token
          
          # Namespace the title by the user's email so that no global titles conflict
          formatted_title = format_title title, email
          
          # select just the appropriate node
          node = fetch_node digital_ocean_client, formatted_title 
          
          if node.empty?
            # Confirm that the node got created in 1 minute
            Resque.enqueue_in(1.minutes, BigEarth::Blockchain::ConfirmNodeCreated, title, email)
          else
            ipv4_address = node.first['networks']['v4'].first['ip_address']
            ipv6_address = node.first['networks']['v6'].first['ip_address']
            existing_node = Chain.where('title = ?', title).first
            existing_node.node_created = true
            existing_node.ipv4_address = ipv4_address
            existing_node.ipv6_address = ipv6_address
            existing_node.save
            flavor = existing_node.flavor
            
            # Describe infrastructure
            config = {
              type: 'blockchain',
              options: {
                title: title,
                flavor: flavor,
                ipv4_address: ipv4_address,
                ipv6_address: ipv6_address
              }
            }
            # Bootstrap the chef Node
            BigEarth::Blockchain::BootstrapInfrastructureJob.perform_later config
            
            # run in 5 minutes
            Resque.enqueue_in 5.minutes, BigEarth::Blockchain::ConfirmInfrastructureBootstrapped, config
          end
          
        # rescue BigEarth::Blockchain::Exceptions::ConfirmNodeCreatedException => error
        rescue => error
          puts "[ERROR] #{Time.now}: #{error.class}: #{error.message}"
        end
      end
    end
  end
end
