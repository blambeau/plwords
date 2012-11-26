ENV['DATABASE_URL'] = ENV['HEROKU_POSTGRESQL_ROSE_URL'] unless ENV['DATABASE_URL']
require './app'
run Sinatra::Application