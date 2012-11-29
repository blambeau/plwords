require 'spec_helper'
describe Model, "submission_words" do

  subject{ 
    test_seed_db.relvar{ submission_words }
  }

  it 'is not empty' do
    subject.should_not be_empty
  end

  it 'is contains expected words' do
    subject.restrict(word: "object").should_not be_empty
    subject.restrict(word: "fun").should_not be_empty
  end

end
