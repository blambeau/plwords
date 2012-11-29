ENV['RACK_ENV'] = "test"
ENV['DATABASE_URL'] = "sqlite://plwords.db"

$:.unshift File.dirname(File.dirname(__FILE__))
require 'app'
require 'rspec'
require 'rack/test'

module Helpers

  def app
    Sinatra::Application
  end

  def test_seed_path
    Path.dir/"../database/seed/test"
  end

  def test_seed_db
    Alf.connect(test_seed_path, default_viewpoint: Model)
  end

end

RSpec.configure do |spec|
  spec.include Helpers
  spec.include Rack::Test::Methods
end