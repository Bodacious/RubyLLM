class Tokenizer
  attr_reader :tokens
  def initialize(document:)
    @tokens = document.to_s.split
  end
end

class NGramCounter
  attr_reader :ngram_counts
  def initialize(tokens:)
    @ngram_counts = tokens.tally
  end
end

class LanguageModel
  DOCUMENT = 'the cat sat on the mat'
  DEFAULT_SEQUENCE_LENGTH = 10

  def initialize
    @probability_distribution = calculate_probability_distribution
  end

  def generate(sequence_length: DEFAULT_SEQUENCE_LENGTH)
    Array.new(sequence_length) { generate_next_token }.join(' ')
  end

  protected

  def generate_next_token
    @probability_distribution.max_by(&:last).first
  end

  def calculate_probability_distribution
    tokens = Tokenizer.new(document: DOCUMENT).tokens
    token_counts = NGramCounter.new(tokens: tokens).ngram_counts
    total_token_count = token_counts.values.sum
    token_counts.transform_values do |count|
      count / total_token_count.to_f
    end
  end
end
