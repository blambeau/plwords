require './configuration'
require 'sinatra'
require 'rest_client'
require 'wlang'

include Configuration
include Alf::Rest::Helpers

use Alf::Rest do |cfg|
  cfg.database = Alf.database(database_url)
  cfg.connection_options = {default_viewpoint: Model}
end

def scope
  @scope ||= { languages: relvar(:languages).to_a(order: [[:language, :asc]]) }
end

get '/' do
  wlang :contribute, locals: scope
end

get %r{^/clouds(/(.+))?} do |_,language|
  wlang :clouds, locals: scope.merge(language: language)
end

get '/cloud/:language' do
  content_type :json
  relvar(:wordcloud_by_language)
    .restrict(language: params[:language])
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
      { 'privatekey' => '6Lf1x9kSAAAAABgcLX5rCTorU_Ols02NWfFrlvo9',
        'remoteip'   => request.ip,
        'challenge'  => params['recaptcha_challenge_field'],
        'response'   => params['recaptcha_response_field'] }
    errors << 'recaptcha' unless check =~ /\Atrue/
  end
  if errors.empty?
    relvar(:submissions)
      .insert(language: lang, feeling: feeling, submission_ip: request.ip)
    201
  else
    [ 400, {'Content-Type' => 'application/json'}, errors.to_json ]
  end
end
