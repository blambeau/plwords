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

      post '/words', words: "enterprise"
      last_response.status.should eq(400)
    end
  end

end