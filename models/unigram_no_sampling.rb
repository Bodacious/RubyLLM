# frozen_string_literal: true

require 'bundler'

Bundler.setup(:development)

class UnigramNoSampling
  CORPUS = "the cat sat on the mat".split
  MAX_TOKENS = 10

  TokenProbability = Data.define(:token, :probability)

  def initialize
    @probability_distributions = calculate_probability_distributions
  end

  def generate(sequence_length = MAX_TOKENS)
    Array.new(sequence_length) { generate_next_token }.join(" ")
  end

  protected

  def generate_next_token
    @probability_distributions.max_by(&:probability).token
  end

  def calculate_probability_distributions
    token_counts = CORPUS.tally
    total_token_count = token_counts.values.sum
    token_counts.map do |token, count|
      probability = Rational(count, total_token_count)
      TokenProbability[token, probability.to_f]
    end
  end
end
