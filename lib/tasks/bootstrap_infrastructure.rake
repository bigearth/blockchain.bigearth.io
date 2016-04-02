namespace :blockchain do
  desc "Bootstraps infrastructure for use in the Big Earth Blockchain platform"
  task :bootstrap_infrastructure, [:type, :title, :email, :flavor] => :environment do |task, args|
    # format data
    config = {
      type: args[:type],
      title: args[:title],
      email: args[:email],
      options: {
        flavor: args[:flavor]
      }
    }
    puts "Boostrapping infrastructure of type: '#{config[:type]}' w/ title: '#{config[:title]}', email: #{config[:email]} and options: '#{config[:options]}'"
    # Create node
    BigEarth::Blockchain::CreateNodeJob.perform_later config
  end
end
