# test_next_token_generator.rb
require "test_helper"

require "next_token_generator"

class NextTokenGeneratorTest < Minitest::Test
  def test_generate_next_returns_last_token_of_highest_probability_ngram
    ngram_mock = mock("NGram") # 1,2,3,4
    ngram_mock.stubs(:start_with?).with([1,2,3]).returns(true)
    ngram_mock.stubs(:last_token).returns(4)

    ngram_prob_mock = mock("NGramProbability")
    ngram_prob_mock.stubs(:ngram).returns(ngram_mock)
    ngram_prob_mock.stubs(:probability).returns(0.9)

    generator = NextTokenGenerator.new(probability_distributions: [ngram_prob_mock])

    result = generator.generate_next(context: [1,2,3])

    assert_equal 4, result
  end

  def test_generate_next_returns_terminating_token_when_no_match
    skip "rethink this."
    eos_token = 1000
    Tokenizer.stubs(:eos_tokens).returns([1000])

    # Stub NGramProbability.new for TERMINATING_NGRAM_PROBABILITY
    ngram_mock = mock("NGram")
    ngram_mock.stubs(:start_with?).returns(false)
    ngram_mock.stubs(:last_token).returns(1000)

    terminating_prob = mock("NGramProbability")
    terminating_prob.stubs(:ngram).returns(ngram_mock)

    generator = NextTokenGenerator.new(probability_distributions: [])
    result = generator.generate_next(context: "foo")

    assert_equal eos_token, result
  end

  def test_probability_distributions_are_sorted_on_initialization
    low_prob = mock("NGramProbability (low prob)")
    low_prob.stubs(:probability).returns(0.1)
    low_prob.stubs(:ngram).returns(
      mock('NGram (low prob)', start_with?: true)
    )

    high_prob = mock("NGramProbability (high prob)")
    high_prob.stubs(:probability).returns(0.9)
    high_prob.stubs(:ngram).returns(
      mock('NGram (high prob)', start_with?: true, last_token: 1000)
    )

    generator = NextTokenGenerator.new(probability_distributions: [low_prob, high_prob])

    assert_equal 1000, generator.generate_next(context: 100)
  end
end
