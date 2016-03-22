namespace :db do
  desc "Drop, create and then migrate the database."

  task reseed: [
    'db:drop',
    'db:create:all',
    #'db:structure:load',
    'db:migrate',
    #'db:seed',
    #'db:test:prepare'
  ]
end
