require './configuration'
require 'sinatra'
require 'wlang'

include Configuration
include Alf::Rest::Helpers

use Alf::Rest do |cfg|
  cfg.database = Alf.database(database_url)
  cfg.connection_options = {default_viewpoint: Model}
end

get '/' do
  langs = relvar{
    languages
  }.to_a(order: [[:name, :asc]])
  wlang :contribute, locals: { languages: langs }
end

get '/clouds' do
  langs = relvar{
    languages
  }.to_a(order: [[:name, :asc]])
  wlang :clouds, locals: { languages: langs }
end

get '/cloud/:language' do
  content_type :json
  lang = params[:language]
  x = relvar{
    project(
      ungroup(
        restrict(wordcloud_by_language, language: lang),
        :histogram),
      [:word, :frequency])
  }.to_json(order: [[:frequency, :desc], [:word, :asc]])
end

post '/submissions' do
  halt(400, 'language') unless lang=params['language']
  halt(400, 'language') if lang.empty? or lang.size>50
  halt(400, 'feeling')  unless feeling=params['feeling']
  halt(400, 'feeling')  if feeling.empty? or feeling.size>500
  lang, feeling = lang.strip, feeling.strip
  relvar(:submissions).insert(language: lang, feeling: feeling, submission_ip: request.ip)
  201
end
