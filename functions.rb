module Functions

  def normalize_language(lang)
    lang.downcase
  end

  def feeling2words(feeling)
    Relation(word: feeling.split(/\W+/).map(&:downcase))
  end

end