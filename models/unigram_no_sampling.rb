# frozen_string_literal: true

require 'bundler'

Bundler.setup(:development)

class UnigramNoSampling
  CORPUS = "the cat sat on the mat".split
  MAX_TOKENS = 10
  def generate(sequence_length = MAX_TOKENS)
    counts = Hash.new(0)
    CORPUS.each { |tok| counts[tok] += 1 }
    total = counts.values.sum.to_f
    probs = counts.transform_values { |c| c / total }
    generate_next_token = Proc.new do |(_token_a, prob_a), (_token_b, prob_b)|
      probs.sort_by { prob_b <=> prob_a }.first.first
    end
    sequence_length.times.map(&generate_next_token).join(" ")
  end
end
