require 'spec_helper'

describe "GET /clouds/:language" do

  it 'work fine with an explicit language' do
    get '/clouds/java'
    last_response.should be_ok
  end

  it 'work fine with no explicit language' do
    get '/clouds/'
    last_response.should be_ok

    get '/clouds'
    last_response.should be_ok
  end

end
