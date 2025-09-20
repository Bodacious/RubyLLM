# frozen_string_literal: true

require 'bundler'

Bundler.setup(:development)

class UnigramNoSampling
  CORPUS = "the cat sat on the mat".split
  MAX_TOKENS = 10

  def initialize
    @probability_distributions = calculate_probability_distributions
  end
  def generate(sequence_length = MAX_TOKENS)
    sequence_length.times.map { generate_next_token }.join(" ")
  end

  def generate_next_token
    sorted_distributions = @probability_distributions.sort_by do |(token_a,prob_a),(token_b, prob_b)|
      prob_b <=> prob_a
    end
    most_prevalent_token = sorted_distributions.first
    most_prevalent_token.first
  end

  def calculate_probability_distributions
    counts = Hash.new(0)
    CORPUS.each { |tok| counts[tok] += 1 }
    total = counts.values.sum.to_f
    counts.transform_values { |c| c / total }
  end
end
