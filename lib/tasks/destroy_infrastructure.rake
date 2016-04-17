namespace :blockchain do
  desc "Destroys infrastructure from the Big Earth Blockchain platform"
  task :destroy_infrastructure, [:type, :title, :email] => :environment do |task, args|
    # format data
    config = {
      type: args[:type],
      title: args[:title],
      email: args[:email]
    }
    puts "Destroying infrastructure of type: '#{config[:type]}' w/ title: '#{config[:title]}' and email: '#{config[:email]}'"
    # Create node
    BigEarth::Blockchain::DestroyNodeJob.perform_later config
    
    # Destroy the DNS A record
    BigEarth::Blockchain::DestroyDNSRecordJob.perform_later config
    
    # # Send out email
    # if args[:type] == 'blockchain'
    #   BigEarth::Blockchain::ChainDestroyedEmailJob.perform_later @user, @chain
    # else
    #   BigEarth::Blockchain::InfrastructureDestroyedEmailJob.perform_later config
    # end
  end
end
