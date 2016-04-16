module BigEarth
  module Blockchain
    class DestroyDNSRecord < ActiveJob::Base
      include BigEarth::Blockchain::Utility
      
      # Set queue
      queue_as :destroy_dns_record_job
      
      def perform config
        puts "CONFIG: #{config}"
        # Wrap in begin/rescue block
        begin
          # Get the CloudFlare Client
          cloudflare = CloudFlare::connection Figaro.env.cloudflare_api_key, Figaro.env.cloudflare_email
          
          # Fetch all DNS records
          resp = cloudflare.rec_load_all Figaro.env.cloudflare_domain
          
          # Namespace the title by the user's email so that no global titles conflict
          formatted_title = format_title config['title'], config['email']
          puts "FORMATTED TITLE: #{formatted_title}"
          
          # Loop over records
          resp['response']['recs']['objs'].each do |rec|
            puts "****************************************************"
            puts rec
            # Find the record for this subdomain
            if rec['name'] ==  "#{formatted_title}.bigearth.io"
              # Delete the DNS A record
              cloudflare.rec_delete Figaro.env.cloudflare_domain, rec['rec_id']
            end
          end
        # rescue BigEarth::Blockchain::Exceptions::DestroyDNSRecordException => error
        rescue => error
          puts "[ERROR] #{Time.now}: #{error.class}: #{error.message}"
        end
      end
    end
  end
end
