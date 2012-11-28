require 'sinatra'
require 'wlang'
require 'sequel'

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
  query{ words }.size.to_s
end

post '/words' do
  halt(400, 'language') unless lang=params['language']
  halt(400, 'language') if lang.empty? or lang.size>50
  halt(400, 'words')    unless words=params['words']
  halt(400, 'words')    if words.empty? or words.size>500
  relvar(:words).insert(language: lang, words: words, submission_ip: request.ip)
  201
end