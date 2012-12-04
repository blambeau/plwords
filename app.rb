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

HISTOGRAM_ORDERING = [[:frequency, :desc], [:word, :asc]]

class MyHtml < WLang::Html

  def at(buf, href, label)
    href, label = render(href), render(label)
    buf << %Q{<a target="_blank" href="#{href}">#{label}</a>}
  end
  tag '@', :at
end

configure do
  set :recaptcha_private, ENV['RECAPTCHA_PRIVATE']
  set :recaptcha_public,  ENV['RECAPTCHA_PUBLIC']
  set :logger, development? ? Logger.new(STDOUT) : nil
  set :wlang, {dialect: MyHtml}
  alf_rest do |cfg|
    cfg.database  = Sequel.connect(ENV['DATABASE_URL'], loggers: [ settings.logger ].compact)
    cfg.viewpoint = Model
  end
end

def scope
  @scope ||= { languages: relvar(:languages).to_a(order: [[:language, :asc]]) }
end

get '/' do
  wlang :contribute, locals: scope.merge(recaptcha: settings.recaptcha_public)
end

get %r{^/clouds(/(.+))?} do |_,language|
  wlang :clouds, locals: scope.merge(language: language)
end

get '/cloud/:language' do
  content_type :json
  relvar(:wordcloud_by_language)
    .restrict(language: params[:language].downcase)
    .ungroup(:histogram)
    .project([:word, :frequency])
    .to_json(order: [[:frequency, :desc], [:word, :asc]])
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
