module BigEarth 
  module Blockchain 
    class CreateNodeJob < ActiveJob::Base
      include BigEarth::Blockchain::Utility

      # Set queue
      queue_as :create_node_job

      def perform config
        # param: config
        #  * Hash
        #    * type (mandatory)
        #    * title (mandatory)
        #    * options (optional)
        #      * email (optional)
        #      * flavor (optional)
        # TODO: Add Exception handling here for missing mandatory config attributes
        
        # Wrap in begin/rescue block
        begin
          
          # Get the Digital Ocean Client
          digital_ocean_client = DropletKit::Client.new access_token: Figaro.env.digital_ocean_api_token
          
          # Namespace the title by the user's email so that no global titles conflict
          formatted_title = format_title config[:title], config[:options][:email]
          
          # select just the appropriate node
          node = fetch_node digital_ocean_client, formatted_title 
          
          if node.empty?
            
            # If node doesn't exist then create it
            # Hardcoded values for now. Will likely change that in the future as the dashboard becomes more fully featured
            new_node = DropletKit::Droplet.new({
              name: formatted_title, 
              region: 'sfo1', 
              size: '8gb', 
              ssh_keys: [ Figaro.env.ssh_key_id ],
              image: 'ubuntu-14-04-x64', 
              ipv6: true
            })
            
            # Create it
            digital_ocean_client.droplets.create new_node
              
            # Update Active Record w/ Blockchain flavor
            existing_node = Chain.where('title = ?', config[:title]).first
            existing_node.flavor = config[:options][:flavor]
            existing_node.save
            
            # Confirm that the node got created in 1 minute
            Resque.enqueue_in(1.minutes, BigEarth::Blockchain::ConfirmNodeCreated, config[:title], config[:options][:email])
          else
            raise BigEarth::Blockchain::Exceptions::CreateNodeException.new "Chain `#{config[:title]}` already exists for user `#{config[:options][:email]}`"
          end
        rescue => error
          puts "[ERROR] #{Time.now}: #{error.class}: #{error.message}"
        end
      end
    end
  end
end
