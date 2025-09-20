# frozen_string_literal: true

require 'bundler'

Bundler.setup(:development)

class UnigramNoSampling
  CORPUS = "the cat sat on the mat".split
  MAX_TOKENS = 10

  TokenProbability = Data.define(:token, :probability)

  def initialize
    @token_counts = CORPUS.tally
    @probability_distributions = calculate_probability_distributions
  end

  def generate(sequence_length = MAX_TOKENS)
    sequence_length.times.map { generate_next_token }.join(" ")
  end

  protected

  def generate_next_token
    sorted_distributions = @probability_distributions.sort_by(&:probability).reverse
    most_prevalent_token = sorted_distributions.first
    most_prevalent_token.token
  end

  def calculate_probability_distributions
    @token_counts.map do |token, count|
      probability = count / total_token_count
      TokenProbability[token, probability]
    end
  end

  def total_token_count = @token_counts.values.sum.to_f

end
