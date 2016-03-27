namespace :blockchain do
  desc "Bumps current version per Semantic Versioning (http://semver.org/)"
  task :bump_version, [:major, :minor, :patch] => :environment do |task, args|
    file = File.open 'VERSION', 'w'
    file.write "#{args.major}.#{args.minor}.#{args.patch}"
    file.close
  end
  
  desc "Shows current version per Semantic Versioning (http://semver.org/)"
  task show_version: :environment do |task, args|
    puts "Version: #{File.open("VERSION").read}"
  end
end
