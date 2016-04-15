module BigEarth
  module Blockchain
    class CreateDNSRecord
      extend BigEarth::Blockchain::Utility
      
      # Set queue
      @queue = "#{Rails.env}_create_dns_record_worker"
      
      def self.perform config
        # Wrap in begin/rescue block
        begin
          # Get the Digital Ocean Client
          digital_ocean_client = DropletKit::Client.new access_token: Figaro.env.digital_ocean_api_token
          
          # Namespace the title by the user's email so that no global titles conflict
          formatted_title = format_title config['title'], config['email']
          
          # select just the appropriate node
          node = fetch_node digital_ocean_client, formatted_title 
          
          if node.empty?
            # Confirm that the node got created in 1 minute
            Resque.enqueue_in 15.seconds, BigEarth::Blockchain::CreateDNSRecord, config
          else
            # Get the CloudFlare Client
            cloudflare = CloudFlare::connection(Figaro.env.cloudflare_api_key, Figaro.env.cloudflare_email)
            
            # Create new A record
            cloudflare.rec_new(Figaro.env.cloudflare_domain, 'A', "#{formatted_title}.cloud", node.first['networks']['v4'].first['ip_address'], 1)
          end
        # rescue BigEarth::Blockchain::Exceptions::CreateDNSRecordException => error
        rescue => error
          puts "[ERROR] #{Time.now}: #{error.class}: #{error.message}"
        end
      end
    end
  end
end
