module Model
  include Alf::Viewpoint
  include Functions

  native :submissions

  def cleaned_submissions
    extend(
      submissions,
      language: ->{ language.downcase })
  end

  def languages
    summarize(
      cleaned_submissions,
      [:language],
      submission_count: count())
  end

  def wordcloud_by_language
    s = self
    allbut(
      extend(
        summarize(
          cleaned_submissions,
          [:language],
          feeling: concat(between: "\n"){ feeling },
          submission_count: count()),
        histogram: ->{ s.histogram(feeling) }),
      [:feeling])
  end
end
