# frozen_string_literal: true

require 'test_helper'
require_relative '../../models/unigram_no_sampling'

class UnigramNoSamplingTest < Minitest::Test
  def test_generate_returns_the_n_times
    model = UnigramNoSampling.new

    sample_text = model.generate(10)

    assert_equal 'the the the the the the the the the the', sample_text
  end
end
