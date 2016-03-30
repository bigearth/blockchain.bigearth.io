module BigEarth 
  module Blockchain 
    module Utility
      def format_title title, email
        # TODO remove `!` character. Chef complains:  
        # Invalid Request Data:
        # The data in your request was invalid (HTTP 400).
        # Server Response:
        # Invalid client name 'bigearth!' using regex: 'Malformed client name.  Must be A-Z, a-z, 0-9, _, -, or .'.
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
