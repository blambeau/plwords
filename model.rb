require 'alf'
require 'alf-sequel'
require 'alf-rest'

module Model
  include Alf::Viewpoint
  include Functions

  native :submissions

  def wordcloud_by_language
    s = self
    allbut(
      extend(
        summarize(
          extend(
            submissions,
            language: ->{ language.downcase }),
          [:language],
          feeling: concat(between: "\n"){ feeling },
          submission_count: count()),
        histogram: ->{ s.histogram(feeling) }),
      [:feeling])
  end
end
