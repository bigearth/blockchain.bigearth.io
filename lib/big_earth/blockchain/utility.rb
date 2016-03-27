module BigEarth 
  module Blockchain 
    module Utility
      def format_title title, email
        "#{email.split('@').first}-#{Rails.env}-#{title.dasherize.parameterize}"
      end
       
      def fetch_droplet digital_ocean_client, title
        # select just the appropriate droplet
        digital_ocean_client.droplets.all.select do |droplet|  
          droplet.name === title 
        end 
      end
    end
  end
end
