module Model
  include Alf::Viewpoint

  def histogram(text)
    histo = text.split(/\W+/)
                .map(&:downcase)
                .each_with_object(Hash.new 0){|w,h| h[w] += 1 }
    Relation histo.each_pair.map{|w,f| {word: w, frequency: f}}
  end

  native :submissions

  def languages
    summarize(
      submissions,
      [:language],
      submission_count: count())
  end

  def wordcloud_by_language
    s = self
    allbut(
      extend(
        summarize(
          submissions,
          [:language],
          feeling: concat(between: "\n"){ feeling },
          submission_count: count()),
        histogram: ->{ s.histogram(feeling) }),
      [:feeling])
  end
end
