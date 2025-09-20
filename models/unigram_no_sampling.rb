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
    generate_next_token = Proc.new do |(_token_a, prob_a), (_token_b, prob_b)|
      @probability_distributions.sort_by { prob_b <=> prob_a }.first.first
    end
    sequence_length.times.map(&generate_next_token).join(" ")
  end

  def calculate_probability_distributions
    counts = Hash.new(0)
    CORPUS.each { |tok| counts[tok] += 1 }
    total = counts.values.sum.to_f
    counts.transform_values { |c| c / total }
  end
end
