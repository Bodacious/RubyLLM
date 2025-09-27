# test_sampling_strategies_minitest.rb
require "test_helper"
require_relative "../../lib/corpus"

class CorpusTest < Minitest::Test
  def test_reads_text_file_and_returns_samples_with_BOS_EOS
    corpus = Corpus.new(name: :simple)

    assert_equal "[BOS]the cat sat on the mat[EOS]", corpus.samples.first
  end
end
