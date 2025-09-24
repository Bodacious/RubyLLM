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

    assert_equal <<~STRING.chomp, sample_text
      these motives urged me forward; i seemed to forget those friends who \
      were so many misfortunes weigh upon you, but to adapt my nature had the \
      shape of a mummy.
    STRING
    refute_empty sample_text
  end

  def test_returns_sensible_content_when_prompt_is_night
    model = TrigramLargeCorpus.new

    sample_text = model.generate(prompt: "and when I left", sequence_length: 100)

    # THIS IS COMPLETELY GENERATED CONTENT!
    assert_equal "and when i left him incredulous to the vessel.", sample_text
    refute_empty sample_text
  end
end
