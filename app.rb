require 'sinatra'
require 'sequel'
require 'thread'

LOCK = Mutex.new
DB   = Sequel.connect("sqlite://plwords.db")

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