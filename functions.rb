module Functions

  def normalize_language(lang)
    lang.downcase
  end

  def feeling2words(feeling)
    Relation(word: feeling.split(/\W+/).map(&:downcase))
  end

  def histogram(text)
    histo = text.split(/\W+/)
                .map(&:downcase)
                .each_with_object(Hash.new 0){|w,h| h[w] += 1 }
    Relation histo.each_pair.map{|w,f| {word: w, frequency: f}}
  end

end