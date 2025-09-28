# test_sampling_strategies_minitest.rb
require "test_helper"
require_relative "../../lib/corpus"

class CorpusTest < Minitest::Test
  def test_reads_text_file_and_returns_samples_with_BOS_EOS
    corpus = Corpus.new(name: :simple)

    assert_equal "!!! the cat sat on the mat``", corpus.samples.first
  end
end
