module BigEarth 
  module Blockchain 
    class DestroyNodeJob < ActiveJob::Base
      include BigEarth::Blockchain::Utility

      # Set queue
      queue_as :destroy_node_job

      def perform title, email 
        # Wrap in begin/rescue block
        begin
          # Get the Digital Ocean Client
          digital_ocean_client = DropletKit::Client.new access_token: Figaro.env.digital_ocean_api_token
          
          # Namespace the title by the user's email so that no global titles conflict
          formatted_title = format_title title, email
              
          # select just the appropriate node
          node = fetch_node digital_ocean_client, formatted_title 
          
          unless node.empty?
            # IF the node exists then delete it
            digital_ocean_client.droplets.delete id: node.first['id']
          end
          
          # raise BigEarth::Blockchain::Exceptions::DestroyNodeException.new "Chain `#{chain[:title]}` already exists for user `#{user.email}`"
        rescue => error
          puts "[ERROR] #{Time.now}: #{error.class}: #{error.message}"
        end
      end
    end
  end
end
