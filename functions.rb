module Functions

  def histogram(text)
    histo = text.split(/\W+/)
                .map(&:downcase)
                .each_with_object(Hash.new 0){|w,h| h[w] += 1 }
    Relation histo.each_pair.map{|w,f| {word: w, frequency: f}}
  end

end