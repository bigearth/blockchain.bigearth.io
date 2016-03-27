module BigEarth 
  module Blockchain 
    module Utility
      def format_title title, email
        "#{email.split('@').first}-#{Rails.env}-#{title.dasherize.parameterize}"
      end
       
      def fetch_node digital_ocean_client, title
        # select just the appropriate node
        digital_ocean_client.droplets.all.select do |node|  
          node.name === title 
        end 
      end
    end
  end
end
