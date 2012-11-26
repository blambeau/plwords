require 'sinatra'
require 'sequel'
require 'thread'

LOCK = Mutex.new

configure :test do
  set :db, Sequel.connect("sqlite://plwords.db")
end

post '/words' do
  if lang=params['language'] and words=params['words']
    LOCK.synchronize do
      settings.db[:words].insert(language: lang, words: words, submission_ip: request.ip)
      201
    end
  else
    400
  end
end