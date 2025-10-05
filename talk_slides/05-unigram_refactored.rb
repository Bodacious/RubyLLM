# frozen_string_literal: true

class Tokenizer
  def tokenize(*samples)
    samples.flat_map { |sample| sample.to_s.split }
  end

  def detokenize(tokens)
    tokens.join(" ")
  end
end

class NGramCounter
  attr_reader :ngram_counts

  def initialize(tokens:)
    @ngram_counts = tokens.tally
  end
end

class ProbabilityDistribution
  TokenProbability = Data.define(:token, :probability)
  def initialize(ngram_counts: {})
    @ngram_counts = ngram_counts
  end

  def distribution
    return @distribution if defined?(@distribution)

    total = @ngram_counts.values.sum
    @distribution = @ngram_counts.map do |token, count|
      TokenProbability[token, count / total.to_f]
    end
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
    @probability_distribution.max_by(&:probability).token
  end

  def calculate_probability_distribution
    tokens = @tokenizer.tokenize(DOCUMENT)
    token_counts = NGramCounter.new(tokens: tokens).ngram_counts
    ProbabilityDistribution.new(ngram_counts: token_counts).distribution
  end
end
