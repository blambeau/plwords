require 'sequel'
require 'alf'
require 'alf-sequel'
require 'alf-rest'

require './functions'
require './model'

module Configuration

  ROOT = Path.backfind('.[config.ru]')

  def infer_environment
    (ENV['RACK_ENV'] || 'development').to_sym
  end

  def database_url
    case env=infer_environment
    when :production  then ENV['DATABASE_URL'] || ENV['HEROKU_POSTGRESQL_ROSE_URL']
    when :test        then "sqlite://database/test.db"
    when :development then "sqlite://database/devel.db"
    else
      raise "Unrecognized environment: #{env}"
    end
  end

  def seed_url
    ROOT/"database/seed/#{infer_environment}"
  end

end