require 'sinatra'
require 'wlang'
require 'sequel'
require 'alf'
require 'alf-sequel'
require 'alf-rest'

use Alf::Rest do |cfg|
  cfg.database = Alf.database(ENV['DATABASE_URL'])
end
include Alf::Rest::Helpers

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
  halt(400, 'tags')     unless tags=params['tags']
  halt(400, 'tags')     if tags.empty? or tags.size>500
  relvar(:submissions).insert(language: lang, tags: tags, submission_ip: request.ip)
  201
end