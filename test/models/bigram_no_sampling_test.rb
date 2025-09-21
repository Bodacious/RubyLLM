require 'test_helper'
require_relative '../../models/bigram_no_sampling'

class BigramNoSamplingTest < Minitest::Test

  def test_generate_returns_only_prompt_string_when_prompt_not_in_corpus
    model = BigramNoSampling.new

    sample_text = model.generate(prompt: "foo", sequence_length: 5)

    assert_equal "foo", sample_text
  end

  def test_generate_returns_content_when_word_in_corpus
    model = BigramNoSampling.new

    sample_text = model.generate(prompt: "cat", sequence_length: 5)

    assert_equal "cat sat on the cat", sample_text
  end

  def test_generate_returns_the_correct_sequence_length
    model = BigramNoSampling.new

    sample_text = model.generate(prompt: "cat", sequence_length: 10)

    assert_equal 10, sample_text.split.length
  end

  def test_generate_returns_most_probable_output_with_correct_start_prompt
    model = BigramNoSampling.new

    sample_text = model.generate(prompt: "the", sequence_length: 6)

    # This is ending in "cat" not "mat"
    assert_equal "the cat sat on the cat", sample_text
  end
end
