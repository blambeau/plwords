require 'spec_helper'
describe Model, "histogram" do
  include Model

  it 'works as expected' do
    expected = Relation([
      {word: "enterprise", frequency: 2},
      {word: "typed", frequency: 1},
      {word: "statically", frequency: 1},
      {word: "for", frequency: 1}
    ])
    histogram("enterprise\nstatically typed\nfor enterprise").should eq(expected)
  end

end
