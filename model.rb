require 'alf'
require 'alf-sequel'
require 'alf-rest'

module Model
  include Alf::Viewpoint
  include Functions

  native :submissions

  def submission_words
    s = self
    ungroup(
      allbut(
        extend(
          project(submissions, [:submission_id, :language, :feeling]),
          language: ->{ s.normalize_language(language) },
          words:    ->{ s.feeling2words(feeling)       }),
        [:feeling]),
      :words)
  end
end
