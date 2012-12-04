require 'sequel'
require 'path'
require 'alf'
require 'alf-sequel'
require 'alf-rest'
require 'sinatra'
require 'sinatra/alf-rest'
require 'rest_client'
require 'wlang'
require 'logger'
require './config'
require './model'
require './dialect'

configure do
  set :recaptcha_private, ENV['RECAPTCHA_PRIVATE']
  set :recaptcha_public,  ENV['RECAPTCHA_PUBLIC']
  set :logger, development? ? Logger.new(STDOUT) : nil
  set :wlang, { dialect: Dialect }
  alf_rest do |cfg|
    cfg.database  = Sequel.connect(ENV['DATABASE_URL'], loggers: [ settings.logger ].compact)
    cfg.viewpoint = Model
  end
end

get '/about' do
  wlang :about
end

get %r{^(/|/languages/?)$} do
  scope = {
    language:  nil,
    languages: relvar(:languages)
                 .to_a(order: [[:language, :asc]]),
    histogram: relvar(:languages)
                 .rename(language: :word, submission_count: :frequency)
                 .extend(frequency: ->{ frequency/2 })
                 .to_a(order: [[:frequency, :desc], [:word, :asc]]),
    mode:      'language'
  }
  wlang :languages, locals: scope
end

get '/languages/:language' do |lang|
  lang = lang.downcase
  scope = {
    language:  lang,
    languages: relvar(:languages)
                 .extend(active: ->{ language == lang })
                 .to_a(order: [[:language, :asc]]),
    histogram: relvar(:words)
                 .restrict(language: lang)
                 .project([:word, :frequency])
                 .to_a(order: [[:frequency, :desc], [:word, :asc]]),
    mode: 'tag'
  }
  wlang :languages, locals: scope
end

get '/contribute' do
  scope = {
    languages: relvar(:languages).to_a(order: [[:language, :asc]]),
    recaptcha: settings.recaptcha_public
  }
  wlang :contribute, locals: scope
end

post '/submissions' do
  errors = []
  lang, feeling = params.values_at('language', 'feeling').map{|x| x || '' }.map(&:strip)
  errors << 'language' if lang.empty?    or lang.size>50
  errors << 'feeling'  if feeling.empty? or feeling.size>500
  unless settings.test?
    check = RestClient.post "http://www.google.com/recaptcha/api/verify",
      { 'privatekey' => settings.recaptcha_private,
        'remoteip'   => request.ip,
        'challenge'  => params['recaptcha_challenge_field'],
        'response'   => params['recaptcha_response_field'] }
    errors << 'recaptcha' unless check =~ /\Atrue/
  end
  if errors.empty?
    relvar(:submissions)
      .insert(language: lang.downcase, feeling: feeling, submission_ip: request.ip)
    201
  else
    [ 400, {'Content-Type' => 'application/json'}, errors.to_json ]
  end
end
