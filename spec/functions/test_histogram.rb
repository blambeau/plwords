require 'spec_helper'
describe Functions, "histogram" do
  include Functions

  it 'works as epected' do
    expected = Relation([
      {word: "enterprise", frequency: 2},
      {word: "typed", frequency: 1},
      {word: "statically", frequency: 1},
      {word: "for", frequency: 1}
    ])
    histogram("enterprise\nstatically typed\nfor enterprise").should eq(expected)
  end

end
