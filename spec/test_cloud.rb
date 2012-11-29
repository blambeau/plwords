require 'spec_helper'

describe "GET /cloud/java" do

  it 'should work fine' do
    get '/cloud/java'
    last_response.should be_ok
    last_response.body.should_not =~ /\+\{words\}/
  end

end
