require 'alf'
require 'alf-sequel'
require 'alf-rest'

module Model
  include Alf::Viewpoint
  include Functions

  native :submissions

  def submission_histograms
    s = self
    extend(
      submissions,
      histogram: ->{ s.histogram(feeling) })
  end
end
