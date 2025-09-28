# test/next_token_generator_test.rb
# frozen_string_literal: true

require 'minitest/autorun'
require 'mocha/minitest'
require_relative '../../lib/next_token_generator'

class NextTokenGeneratorTest < Minitest::Test
  def test_generate_next_returns_nil_when_distribution_has_no_tokens
    empty_distribution = mock('ConditionalDistribution')
    empty_distribution.stubs(:tokens).returns([])
    empty_distribution.expects(:next_token).never

    probability_distribution = mock('ProbabilityDistribution')
    probability_distribution.stubs(:distribution_for).with(%w[foo bar]).returns(empty_distribution)

    generator = NextTokenGenerator.new(probability_distribution: probability_distribution)
    result = generator.generate_next(context: %w[foo bar])

    assert_nil result
  end

  def test_generate_next_returns_next_token_when_tokens_exist
    distribution = mock('ConditionalDistribution')
    distribution.stubs(:tokens).returns(%w[baz])
    distribution.stubs(:next_token).returns('baz')

    probability_distribution = mock('ProbabilityDistribution')
    probability_distribution.stubs(:distribution_for).with(%w[foo bar]).returns(distribution)

    generator = NextTokenGenerator.new(probability_distribution: probability_distribution)
    result = generator.generate_next(context: %w[foo bar])

    assert_equal 'baz', result
  end
end
