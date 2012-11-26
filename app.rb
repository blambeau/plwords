require 'sinatra'
require 'sequel'
require 'thread'

LOCK = Mutex.new
DB   = Sequel.connect(ENV['DATABASE_URL'])

get '/status' do
  status 200
  content_type "text/plain"
  DB[:words].count.to_s
end

post '/words' do
  if lang=params['language'] and words=params['words']
    LOCK.synchronize do
      DB[:words].insert(language: lang, words: words, submission_ip: request.ip)
      201
    end
  else
    400
  end
end