require 'spec_helper'

describe "POST /words" do

  context 'with valid words' do

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
      post '/words', language: "java", words: JAVA_WORDS.join("\n")
      last_response.status.should eq(201)
    end

    it 'detects missing params' do
      post '/words'
      last_response.status.should eq(400)

      post '/words', language: "java"
      last_response.status.should eq(400)
      last_response.body.should eq("words")

      post '/words', words: "enterprise"
      last_response.status.should eq(400)
      last_response.body.should eq("language")
    end

    it 'detects empty language' do
      post '/words', language: "", words: "blah"
      last_response.status.should eq(400)
      last_response.body.should eq("language")
    end

    it 'detects empty words' do
      post '/words', language: "ruby", words: ""
      last_response.status.should eq(400)
      last_response.body.should eq("words")
    end

    it 'detects empty language too long' do
      post '/words', language: "A"*1000, words: "blah"
      last_response.status.should eq(400)
      last_response.body.should eq("language")
    end

    it 'detects empty words too long' do
      post '/words', language: "ruby", words: "A"*1000
      last_response.status.should eq(400)
      last_response.body.should eq("words")
    end
  end

end