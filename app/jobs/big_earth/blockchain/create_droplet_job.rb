module BigEarth 
  module Blockchain 
    class CreateDropletJob < ActiveJob::Base

      queue_as :create_chain_job

      def perform user, chain
        # Wrap in begin/rescue block
        begin
          
          # Get the Digital Ocean Client
          @client = DropletKit::Client.new access_token: Figaro.env.digital_ocean_api_token
          
          # select just the appropriate droplet
          droplet = @client.droplets.all.select do |droplet|  
            droplet.name == chain[:title] 
          end 
          
          if droplet.empty?
            
            # Namespace the title by the user's email so that no global titles conflict
            formatted_title = "#{user.email.split('@').first}-#{chain[:title].dasherize.parameterize}"
            
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
            @response = @client.droplets.create new_droplet
              
            # Update Active Record w/ Blockchain flavor
            existing_node = Chain.where('title = ?', chain[:title]).first
            existing_node.flavor = chain[:flavor]
            existing_node.save
            
            # Confirm that the droplet got created in 2 minutes
            Resque.enqueue_in(1.minutes, BigEarth::Blockchain::ConfirmDropletCreated, formatted_title, chain[:title])
          else
            @response = {
              status: 'already_exists'
            }
          end
        rescue Exception => error
          puts "ERROR: #{error}"
          @response = {
            status: 500,
            message: 'Error'
          }
        end
      end
    end
  end
end
