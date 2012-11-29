require 'spec_helper'
describe Functions, "feeling2words" do
  include Functions

  it 'splits around spaces' do
    expected = Relation(word: ["enterprise", "statically", "typed"])
    feeling2words("enterprise\nstatically typed").should eq(expected)
  end

  it 'splits around dashes' do
    expected = Relation(word: ["object", "oriented"])
    feeling2words("object-oriented").should eq(expected)
  end

end
