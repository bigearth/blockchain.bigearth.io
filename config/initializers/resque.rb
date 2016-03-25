# require 'resque/plugins/heroku'
Resque.redis = REDIS
require 'resque-scheduler'
require 'resque/scheduler/server'
# Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }
