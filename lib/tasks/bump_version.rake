namespace :blockchain do
  desc "Bumps current version per Semantic Versioning (http://semver.org/)"
  task :bump_version, [:major, :minor, :patch] => :environment do |task, args|
    new_version = "#{args.major}.#{args.minor}.#{args.patch}"
    puts "This doesn't actually work right now. I'm unclear how to update the VERSION constant"
    puts "New Version: #{new_version}"
  end
  
  desc "Shows current version per Semantic Versioning (http://semver.org/)"
  task show_version: :environment do |task, args|
    puts "Version #{BlockExplorer::Application::VERSION}"
  end
end
