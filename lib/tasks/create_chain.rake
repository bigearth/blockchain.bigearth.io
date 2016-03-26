namespace :blockchain do
  desc "Creates a new blockchain"
  task :create_chain, [:title, :flavor] => :environment do |task, args|
    if args.to_hash == Rake::TaskArguments.new({},{}).to_hash
      user = User.first
      chain = Chain.last
    else
      user = User.first
      chain = args.to_hash
    end
    BigEarth::Blockchain::CreateDropletJob.perform_later user, chain
  end
end
