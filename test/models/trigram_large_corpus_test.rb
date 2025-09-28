# frozen_string_literal: true

require 'test_helper'
require_relative '../../models/trigram_large_corpus'

class TrigramLargeCorpusTest < Minitest::Test
  def test_returns_sensible_content
    srand(60886)

    model = TrigramLargeCorpus.new

    sample_text = model.generate(prompt: 'I cannot pretend to describe')

    assert_equal 'i cannot pretend to describe what i shall not escape, that the discovery of the charming arabian.', sample_text
    refute_empty sample_text
  end

  def test_returns_sensible_content_when_prompt_is_a_few_common_words
    srand(60886)
    model = TrigramLargeCorpus.new

    sample_text = model.generate(prompt: 'and my first of those')

    assert_equal <<~STRING.chomp, sample_text
      and my first of those whose dearest niece, and i have lately occurred.
    STRING
    refute_empty sample_text
  end

  def test_gets_caught_in_loops_on_common_phases
    skip "This behaviour doesn't exist since we introduced sampling"
    model = TrigramLargeCorpus.new

    sample_text = model.generate(prompt: 'but i was')

    assert_includes sample_text,
                    "but i was not, as i was not, as i was not, as i was \
not, as i was not, as i was not, as i was not"
    refute_empty sample_text
  end

  def test_genrates_different_output_for_the_same_prompt
    srand(1000)
    model = TrigramLargeCorpus.new

    sample_text_a = model.generate(prompt: 'but i was')

    srand(2000)
    sample_text_b = model.generate(prompt: 'but i was')

    refute_equal sample_text_a, sample_text_b
  end
end
