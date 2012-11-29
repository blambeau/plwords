require 'spec_helper'

describe "GET /" do

  before do
    get '/'
  end

  it 'displays the html layout' do
    last_response.body.should =~ /Programming Language Word Clouds/ 
  end

  it 'displays the form' do
    last_response.body.should =~ /\<form/
  end

end