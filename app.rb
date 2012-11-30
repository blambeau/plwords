require './configuration'
require 'sinatra'
require 'wlang'

include Configuration
include Alf::Rest::Helpers

use Alf::Rest do |cfg|
  cfg.database = Alf.database(database_url)
  cfg.connection_options = {default_viewpoint: Model}
end

def languages
  @langs ||= relvar{ languages }.to_a(order: [[:name, :asc]])
end

get '/' do
  wlang :contribute, locals: { languages: languages }
end

get /^\/clouds\/?$/ do
  wlang :clouds, locals: { languages: languages,
                            language: languages[rand(languages.size)][:language] }
end

get '/clouds/:language' do
  wlang :clouds, locals: { languages: languages,
                            language: params[:language] }
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
  lang, feeling = params.values_at('language', 'feeling').map{|x| x || '' }.map(&:strip)
  halt(400, 'language') if lang.empty?    or lang.size>50
  halt(400, 'feeling')  if feeling.empty? or feeling.size>500
  relvar(:submissions).insert(language: lang, feeling: feeling, submission_ip: request.ip)
  201
end
