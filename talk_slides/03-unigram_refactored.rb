# frozen_string_literal: true

class Tokenizer
  def tokenize(*samples)
    samples.flat_map { |sample| sample.to_s.split }
  end

  def detokenize(tokens)
    tokens.join(" ")
  end
end

class LanguageModel
  DOCUMENT = "the cat sat on the mat"
  DEFAULT_SEQUENCE_LENGTH = 10

  def initialize
    @tokenizer = Tokenizer.new
    @probability_distribution = calculate_probability_distribution
  end

  def generate(sequence_length: DEFAULT_SEQUENCE_LENGTH)
    sequence = Array.new(sequence_length) { generate_next_token }
    @tokenizer.detokenize(sequence)
  end

  protected

  def generate_next_token
    @probability_distribution.max_by(&:last).first
  end

  def calculate_probability_distribution
    tokens = @tokenizer.tokenize(DOCUMENT)
    token_counts = tokens.tally
    total_token_count = token_counts.values.sum
    token_counts.transform_values do |count|
      count / total_token_count.to_f
    end
  end
end
