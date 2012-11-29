require './configuration'
require 'sinatra'
require 'wlang'

include Configuration
include Alf::Rest::Helpers

use Alf::Rest do |cfg|
  cfg.database = Alf.database(database_url)
  cfg.connection_options = {default_viewpoint: Model}
end

get '/' do
  wlang :form
end

get '/status' do
  status 200
  content_type "text/plain"
  query{ submissions }.size.to_s
end

post '/submissions' do
  halt(400, 'language') unless lang=params['language']
  halt(400, 'language') if lang.empty? or lang.size>50
  halt(400, 'feeling')  unless feeling=params['feeling']
  halt(400, 'feeling')  if feeling.empty? or feeling.size>500
  lang, feeling = lang.strip, feeling.strip
  relvar(:submissions).insert(language: lang, feeling: feeling, submission_ip: request.ip)
  201
end