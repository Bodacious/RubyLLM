# frozen_string_literal: true

class LanguageModel
  DOCUMENT = 'the cat sat on the mat'
  MAX_TOKENS = 10

  def initialize
    @probability_distributions = calculate_probability_distributions
  end

  def generate(sequence_length: MAX_TOKENS)
    Array.new(sequence_length) { generate_next_token }.join(' ')
  end

  protected

  def generate_next_token
    @probability_distributions.max_by(&:last).first
  end

  def calculate_probability_distributions
    token_counts = DOCUMENT.split.tally
    total_token_count = token_counts.values.sum
    token_counts.transform_values { |count| count / total_token_count.to_f }
  end
end
