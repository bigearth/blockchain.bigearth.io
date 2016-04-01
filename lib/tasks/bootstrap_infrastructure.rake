namespace :blockchain do
  desc "Bootstraps infrastructure for use in the Big Earth Blockchain platform"
  task :bootstrap_infrastructure, [:type, :title, :email, :flavor] => :environment do |task, args|
    # format data
    config = {
      type: args[:type],
      title: args[:title],
      options: {
        email: args[:email],
        flavor: args[:flavor]
      }
    }
    # Create node
    BigEarth::Blockchain::CreateNodeJob.perform_later config
  end
end
