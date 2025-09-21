# frozen_string_literal: true

require 'test_helper'
require_relative "../../models/trigram_no_sampling"

class TrigramNoSamplingTest < Minitest::Test
  def test_returns_the_full_output_given_the_prompt_the
    model = TrigramNoSampling.new

    sample_text = model.generate(prompt: "the")

    assert_equal "the cat sat on the mat", sample_text
  end
end
