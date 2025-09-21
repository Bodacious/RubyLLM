require 'test_helper'
require_relative '../../models/bigram_no_sampling'

class BigramNoSamplingTest < Minitest::Test
  def test_generate_returns_the_expected_sentence_with_correct_prompt
    model = BigramNoSampling.new

    sample_text = model.generate(prompt: "the", sequence_length: 5)

    assert_equal "the cat sat on the mat", sample_text
  end
end
