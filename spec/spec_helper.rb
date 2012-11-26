$:.unshift File.dirname(File.dirname(__FILE__))
require 'app'
require 'rspec'
require 'rack/test'

set :environment, :test

module Helpers

  def app
    Sinatra::Application
  end

end

RSpec.configure do |spec|
  spec.include Helpers
  spec.include Rack::Test::Methods
end