# frozen_string_literal: true

class LanguageModel
  DOCUMENT = 'the cat sat on the mat'
  DEFAULT_SEQUENCE_LENGTH = 10

  def initialize
    @probability_distributions = calculate_probability_distributions
  end

  def generate(sequence_length: DEFAULT_SEQUENCE_LENGTH)
    Array.new(sequence_length) { generate_next_token }.join(' ')
  end

  protected

  TokenProbability = Data.define(:token, :probability)

  def generate_next_token
    @probability_distributions.max_by(&:probability).token
  end

  def calculate_probability_distributions
    token_counts = DOCUMENT.split.tally
    total_token_count = token_counts.values.sum
    token_counts.transform_values { |count| count / total_token_count.to_f }
                .map { |token, probability| TokenProbability[token, probability] }
  end
end
