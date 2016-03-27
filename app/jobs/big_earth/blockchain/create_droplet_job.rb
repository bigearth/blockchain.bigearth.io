module BigEarth 
  module Blockchain 
    class CreateDropletJob < ActiveJob::Base
      include BigEarth::Blockchain::Utility

      # Set queue
      queue_as :create_chain_job

      def perform user, chain
        # Wrap in begin/rescue block
        begin
          
          # Get the Digital Ocean Client
          digital_ocean_client = DropletKit::Client.new access_token: Figaro.env.digital_ocean_api_token
          
          # Namespace the title by the user's email so that no global titles conflict
          formatted_title = format_title chain[:title], user.email
          
          # select just the appropriate droplet
          droplet = fetch_droplet digital_ocean_client, formatted_title 
          
          if droplet.empty?
            
            # If droplet doesn't exist then create it
            # Hardcoded values for now. Will likely change that in the future as the dashboard becomes more fully featured
            new_droplet = DropletKit::Droplet.new({
              name: formatted_title, 
              region: 'sfo1', 
              size: '512mb', 
              ssh_keys: [ Figaro.env.ssh_key_id ],
              image: 'ubuntu-14-04-x64', 
              ipv6: true
            })
            
            # Create it
            digital_ocean_client.droplets.create new_droplet
              
            # Update Active Record w/ Blockchain flavor
            existing_node = Chain.where('title = ?', chain[:title]).first
            existing_node.flavor = chain[:flavor]
            existing_node.save
            
            # Confirm that the droplet got created in 2 minutes
            Resque.enqueue_in(1.minutes, BigEarth::Blockchain::ConfirmDropletCreated, chain[:title], user.email)
          else
            raise BigEarth::Blockchain::Exceptions::CreateDropletException.new "Chain `#{chain[:title]}` already exists for user `#{user.email}`"
          end
        rescue => error
          puts "[ERROR] #{Time.now}: #{error.class}: #{error.message}"
        end
      end
    end
  end
end
