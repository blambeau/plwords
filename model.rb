module Model
  include Alf::Viewpoint

  def histogram(text)
    histo = text.split(/\W+/)
                .map(&:downcase)
                .reject{|w| w.size==1}
                .each_with_object(Hash.new 0){|w,h| h[w] += 1 }
    Relation histo.each_pair.map{|w,f| {word: w, frequency: f}}
  end

  native :submissions
  native :banished_words

  def languages
    summarize(
      submissions,
      [:language],
      submission_count: count())
  end

  def wordcloud_by_language
    s = self
    group(
      not_matching(
        ungroup(
          allbut(
            extend(
              summarize(
                submissions,
                [:language],
              feeling: concat(between: "\n"){ feeling },
              submission_count: count()),
            histogram: ->{ s.histogram(feeling) }),
          [:feeling]),
        :histogram),
      banished_words),
    [:word, :frequency], :histogram)
  end
end
