namespace :blockchain do
  desc "Bumps current version per Semantic Versioning (http://semver.org/)"
  task :bump_version, [:major, :minor, :patch] => :environment do |task, args|
    file = File.open 'VERSION', 'w'
    version = "#{args.major}.#{args.minor}.#{args.patch}"
    file.write version
    puts "New Version: #{version}"
    file.close
  end
  
  desc "Shows current version per Semantic Versioning (http://semver.org/)"
  task show_version: :environment do |task, args|
    puts "Version: #{File.open("VERSION").read}"
  end
end
