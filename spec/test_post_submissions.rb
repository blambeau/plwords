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

  it 'posts successfully with valid params' do
    post '/submissions', language: "java", tags: JAVA_WORDS.join("\n")
    last_response.status.should eq(201)
  end

  it 'detects missing params' do
    post '/submissions'
    last_response.status.should eq(400)

    post '/submissions', language: "java"
    last_response.status.should eq(400)
    last_response.body.should eq("tags")

    post '/submissions', tags: "enterprise"
    last_response.status.should eq(400)
    last_response.body.should eq("language")
  end

  it 'detects empty language' do
    post '/submissions', language: "", tags: "blah"
    last_response.status.should eq(400)
    last_response.body.should eq("language")
  end

  it 'detects empty tags' do
    post '/submissions', language: "ruby", tags: ""
    last_response.status.should eq(400)
    last_response.body.should eq("tags")
  end

  it 'detects empty language too long' do
    post '/submissions', language: "A"*1000, tags: "blah"
    last_response.status.should eq(400)
    last_response.body.should eq("language")
  end

  it 'detects empty tags too long' do
    post '/submissions', language: "ruby", tags: "A"*1000
    last_response.status.should eq(400)
    last_response.body.should eq("tags")
  end

end