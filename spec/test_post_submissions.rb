require 'spec_helper'

describe "POST /submissions" do

  JAVA_WORDS = [
    "enterprise",
    "static typing",
    "safe",
    "verbous",
    "interfaces",
    "desktop",
    "robust",
    "virtual machine",
    "spread",
    "object-oriented"
  ]

  def last_json_body
    JSON.parse(last_response.body)
  end

  it 'posts successfully with valid params' do
    post '/submissions', language: "java", feeling: JAVA_WORDS.join("\n")
    last_response.status.should eq(201)
  end

  it 'detects missing params' do
    post '/submissions'
    last_response.status.should eq(400)
    last_json_body.should eq(['language', 'feeling'])

    post '/submissions', language: "java"
    last_response.status.should eq(400)
    last_json_body.should eq(['feeling'])

    post '/submissions', feeling: "enterprise"
    last_response.status.should eq(400)
    last_json_body.should eq(['language'])
  end

  it 'detects empty language' do
    post '/submissions', language: "", feeling: "blah"
    last_response.status.should eq(400)
    last_json_body.should eq(['language'])
  end

  it 'detects empty feeling' do
    post '/submissions', language: "ruby", feeling: ""
    last_response.status.should eq(400)
    last_json_body.should eq(['feeling'])
  end

  it 'detects empty language too long' do
    post '/submissions', language: "A"*1000, feeling: "blah"
    last_response.status.should eq(400)
    last_json_body.should eq(['language'])
  end

  it 'detects empty feeling too long' do
    post '/submissions', language: "ruby", feeling: "A"*1000
    last_response.status.should eq(400)
    last_json_body.should eq(['feeling'])
  end

end