require 'resque/plugins/heroku'
Resque.redis = REDIS
Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }
