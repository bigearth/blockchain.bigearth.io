module BigEarth 
  module Blockchain 
    module Utility
      def format_title title, email
        "#{email.split('@').first}-#{email.split('@').last}-#{Rails.env}-#{title.tr('@', '').tr('!', '').squish.dasherize.parameterize}"
      end
       
      def fetch_node digital_ocean_client, title
        # TODO Decouple from Digital Ocean and create Node abstraction for library authors to write 3rd party cloud provider plugins
        # select just the appropriate node
        digital_ocean_client.droplets.all.select do |node|  
          node.name === title 
        end 
      end
    end
  end
end
