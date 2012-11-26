require 'sinatra'
require 'sequel'
require 'thread'

LOCK  = Mutex.new
DB    = Sequel.connect(ENV['DATABASE_URL'])
INDEX = File.expand_path('../public/index.html', __FILE__)

get '/' do
  send_file INDEX
end

get '/status' do
  status 200
  content_type "text/plain"
  DB[:words].count.to_s
end

post '/words' do
  halt(400, 'language') unless lang=params['language']
  halt(400, 'language') if lang.empty? or lang.size>50
  halt(400, 'words')    unless words=params['words']
  halt(400, 'words')    if words.empty? or words.size>500
  LOCK.synchronize do
    DB[:words].insert(language: lang, words: words, submission_ip: request.ip)
    201
  end
end