require 'test_helper'
require_relative '../../models/unigram_with_sampling'

class UnigramWithSamplingTest < Minitest::Test
  def test_generate_returns_a_varied_string_with_n_words
    model = UnigramWithSampling.new

    sample_text = model.generate(10)

    refute_equal "the the the the the the the the the the", sample_text
    assert_equal 10, sample_text.split.size
  end
end
