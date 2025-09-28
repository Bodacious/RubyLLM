# frozen_string_literal: true

require 'test_helper'
require_relative "../../models/trigram_large_corpus"

class TrigramLargeCorpusTest < Minitest::Test
  def test_returns_sensible_content
    model = TrigramLargeCorpus.new

    sample_text = model.generate(prompt: "I cannot pretend to describe")

    assert_equal "i cannot pretend to describe what i have no ambition to lose my life on the ground.", sample_text
    refute_empty sample_text
  end

  def test_returns_sensible_content_when_prompt_is_a_few_common_words
    model = TrigramLargeCorpus.new

    sample_text = model.generate(prompt: "and my first of those")

    assert_equal <<~STRING.chomp, sample_text
      and my first of those whose names are recorded in story as the sun had \
      recovered its warmth and rest only that i had been the favourite dream \
      of my own heart.
    STRING
    refute_empty sample_text
  end

  def test_gets_caught_in_loops_on_common_phases
    model = TrigramLargeCorpus.new

    sample_text = model.generate(prompt: "but i was")

    assert_includes sample_text,
                    "but i was not, as i was not, as i was not, as i was \
not, as i was not, as i was not, as i was not"
    refute_empty sample_text
  end
end
