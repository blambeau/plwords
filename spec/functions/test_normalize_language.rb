require 'spec_helper'
describe Functions, "normalize_language" do
  include Functions

  it 'downcases its input string' do
    normalize_language("Java").should eq("java")
  end

end
