module BigEarth 
  module Blockchain 
    class CreateNodeJob < ActiveJob::Base
      include BigEarth::Blockchain::Utility

      # Set queue
      queue_as :create_node_job

      # param: config:hash (mandatory)
      #  * type (mandatory)
      #  * title (mandatory)
      #  * email (mandatory)
      #  * options (optional)
      #    * flavor (optional)
      def perform config
        # Wrap in begin/rescue block
        begin
          if (config[:type].nil? || config[:type] == '') && (config[:title].nil? || config[:title] == '') && (config[:email].nil? || config[:email] == '')
            # Missing all 3
            raise BigEarth::Blockchain::Exceptions::CreateNodeException.new "Missing `type` and `title` and `email` (sheesh you didn't try very hard did you?)"
          elsif (config[:title].nil? || config[:title] == '') && (config[:email].nil? || config[:email] == '')
            # Missing title and email
            raise BigEarth::Blockchain::Exceptions::CreateNodeException.new "Missing `title` and `email`"
          elsif (config[:type].nil? || config[:type] == '') && (config[:email].nil? || config[:email] == '')
            # Missing type and email
            raise BigEarth::Blockchain::Exceptions::CreateNodeException.new "Missing `type` and `email`"
          elsif (config[:type].nil? || config[:type] == '') && (config[:title].nil? || config[:title] == '')
            # Missing type and title
            raise BigEarth::Blockchain::Exceptions::CreateNodeException.new "Missing `type` and `title`"
          elsif config[:type].nil? || config[:type] == ''
            # Missing just type
            raise BigEarth::Blockchain::Exceptions::CreateNodeException.new "Missing `type`"
          elsif config[:title].nil? || config[:title] == ''
            # Missing just title
            raise BigEarth::Blockchain::Exceptions::CreateNodeException.new "Missing `title`"
          elsif config[:email].nil? || config[:email] == ''
            # Missing just title
            raise BigEarth::Blockchain::Exceptions::CreateNodeException.new "Missing `email`"
          end
          
          # Get the Digital Ocean Client
          digital_ocean_client = DropletKit::Client.new access_token: Figaro.env.digital_ocean_api_token
          
          # Namespace the title by the user's email so that no global titles conflict
          formatted_title = format_title config[:title], config[:email]
          
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
            unless existing_node.nil?
              existing_node.flavor = config[:options][:flavor]
              existing_node.save
            end
            
            # Confirm that the node got created in 1 minute
            Resque.enqueue_in 1.minutes, BigEarth::Blockchain::ConfirmNodeCreated, config
          else
            raise BigEarth::Blockchain::Exceptions::CreateNodeException.new "Chain `#{config[:title]}` already exists for user `#{config[:email]}`"
          end
        rescue => error
          puts "[ERROR] #{Time.now}: #{error.class}: #{error.message}"
        end
      end
    end
  end
end
