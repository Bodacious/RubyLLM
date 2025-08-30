# test_sampling_strategies_minitest.rb
require "test_helper"
require_relative "../corpus"

class CorpusTest < Minitest::Test
  def test_tokens_returns_each_word_in_the_string
    corpus = Corpus.new("foo bar")
    assert_equal(corpus.tokens, ["foo", "bar"])
  end

  def test_tokens_returns_each_word_in_the_strings_when_multiple
    corpus = Corpus.new("foo bar", "fizz buzz")
    assert_equal(corpus.tokens, ["foo", "bar", "fizz", "buzz"])
  end
end
