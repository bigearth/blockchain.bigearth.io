web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
resque: env TERM_CHILD=1 QUEUES=* bundle exec rake resque:work
scheduler: bundle exec rake resque:scheduler
