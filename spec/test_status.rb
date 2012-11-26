require 'spec_helper'

describe "GET /status" do

  it 'should work fine' do
    get '/status'
    last_response.should be_ok
    last_response.content_type.should =~ /text\/plain/
  end

end