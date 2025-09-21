# frozen_string_literal: true

require 'test_helper'
require_relative "../../models/trigram_large_corpus"

class TrigramLargeCorpusTest < Minitest::Test
  def test_returns_sensible_content
    model = TrigramLargeCorpus.new

    sample_text = model.generate(prompt: "I am")

    assert_equal "i am alone.", sample_text
    refute_empty sample_text
  end

  def test_returns_sensible_content_when_prompt_is_These
    model = TrigramLargeCorpus.new

    sample_text = model.generate(prompt: "These", sequence_length: 100)

    assert_equal "these motives urged me forward;\
 i seemed to forget those friends who were so many misfortunes weigh upon you,\
 but to adapt my nature had the shape of a library of electronic works, by\
 using or distributing this work i obtained from my infancy i was nourished\
 with high hopes and joys.", sample_text
    refute_empty sample_text
  end

  def test_returns_sensible_content_when_prompt_is_night
    model = TrigramLargeCorpus.new

    sample_text = model.generate(prompt: "and when I left", sequence_length: 100)

    # THIS IS COMPLETELY GENERATED CONTENT!
    assert_equal "night also closed around; and when wrenched by misery\
 without feeling the most verdant islands that relieve the eye and in you for\
 the limited right of replacement or refund described in these works, so full\
 of lofty design and heroism, this elevation of mind preyed upon my hands,\
 as a rock.", sample_text
    refute_empty sample_text
  end
end
