# frozen_string_literal: true

require 'test_helper'
require_relative "../../models/trigram_large_corpus"

class TrigramLargeCorpusTest < Minitest::Test
  def test_returns_sensible_content
    model = TrigramLargeCorpus.new

    sample_text = model.generate(prompt: "the")

    refute_equal "the", sample_text
    refute_empty sample_text
  end
end
