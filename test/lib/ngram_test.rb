# frozen_string_literal: true

require 'test_helper'
require 'ngram'
class NGramTest < Minitest::Test
  def test_last_token_returns_the_last_token_from_the_ngram
    ngram = NGram.new tokens: [1, 2, 3]

    assert_equal 3, ngram.last_token
  end

  def test_start_with_returns_true_if_ngram_contains_the_input_ngrams
    ngram = NGram.new tokens: [1, 2, 3]

    assert ngram.start_with?([1, 2]),
           'expected start_with? to return true'
  end

  def test_start_with_returns_false_if_ngram_does_not_contain_the_input_ngrams
    ngram = NGram.new tokens: [3, 4, 5]

    refute ngram.start_with?([1, 2]),
           'expected start_with? to return false'
  end
end
