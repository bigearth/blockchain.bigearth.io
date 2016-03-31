namespace :blockchain do
  desc "Bootstraps a chef workstation for use in the Big Earth Blockchain platform"
  task :bootstrap_chef_workstation, [:major, :minor, :patch] => :environment do |task, args|
    puts 'boostrapping chef-workstation'
  end
  
  desc "Bootstraps a chef server for use in the Big Earth Blockchain platform"
  task :bootstrap_chef_server, [:major, :minor, :patch] => :environment do |task, args|
    puts 'boostrapping chef-server'
  end
end
