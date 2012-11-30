require 'spec_helper'

describe "GET /cloud/:language" do

  it 'work fine with an explicit language' do
    get '/cloud/java'
    last_response.should be_ok
    last_response.body.should_not =~ /\+\{words\}/
  end

end
