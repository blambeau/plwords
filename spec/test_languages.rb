require 'spec_helper'

describe "GET /languages/:language" do

  it 'work fine with an explicit language' do
    get '/languages/java'
    last_response.should be_ok
  end

  it 'work fine with no explicit language' do
    get '/languages/'
    last_response.should be_ok

    get '/languages'
    last_response.should be_ok
  end

end
