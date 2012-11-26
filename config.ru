ENV['DATABASE_URL'] = ENV['HEROKU_POSTGRESQL_ROSE_URL']
require './app'
run Sinatra::Application