module BigEarth
  module Blockchain
    class ConfirmDropletCreated
      @queue = :confirm_droplet_created_job
      
      def self.perform formatted_title, title
        begin
          client = DropletKit::Client.new access_token: Figaro.env.digital_ocean_api_token
          droplets = client.droplets.all
          droplet = droplets.select do |drplet|  
            drplet.name === formatted_title 
          end 
          
          if droplet.empty?
            # run in 1 minute
            Resque.enqueue_in(1.minutes, BigEarth::Blockchain::ConfirmDropletCreated, title: title)
          else
            # Get IPV4 and IPV6 ip address
            ip_address = droplet.first['networks']['v4'].first['ip_address']
            existing_node = Chain.where('title = ?', title).first
            existing_node.droplet_created = true
            existing_node.ip_address = ip_address
            existing_node.save
            flavor = existing_node.flavor
            
            # Bootstrap the chef Node
            BigEarth::Blockchain::BootstrapChefClientJob.perform_later title, ip_address, flavor
            # run in 1 minute
            Resque.enqueue_in(1.minutes, BigEarth::Blockchain::ConfirmClientBootstrappedJob, title, ip_address, flavor)
          end
          
        rescue Exception => error
          puts "confirm_droplet_created error: #{error}"
        end
      end
    end
  end
end
