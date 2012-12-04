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

  def words
    s = self
    feelings   = summarize(submissions, [:language], feeling: concat(between: "\n"){ feeling })
    histograms = extend(feelings, histogram: ->{ s.histogram(feeling) })
    flattened  = ungroup(histograms, :histogram)
    filtered   = not_matching(flattened, banished_words)
    filtered
  end
end
