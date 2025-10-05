# frozen_string_literal: true

class Tokenizer
  def tokenize(*samples)
    samples.flat_map { |sample| sample.to_s.split }
  end

  def detokenize(*tokens)
    tokens.join(" ")
  end
end

class NGramCounter
  attr_reader :ngram_counts

  def initialize(tokens:, n:)
    @n = n
    # Creates a nested Hash, with default value: 0
    # e.g.
    #   @ngram_counts['foo']['bar'] # => 0
    #   @ngram_counts # => { 'foo' => { 'bar' => 0 }}
    @ngram_counts = Hash.new { |h, k| h[k] = Hash.new(0) }
    count_ngrams(tokens)
  end

  protected

  def count_ngrams(tokens)
    tokens.each_cons(@n) do |ngrams|
      context = ngrams.first
      target = ngrams.last
      @ngram_counts[context][target] += 1
    end
    @ngram_counts
  end
end

class ProbabilityDistribution
  TokenProbability = Data.define(:token, :probability)

  def initialize(ngram_counts: {})
    @ngram_counts = ngram_counts
  end

  def distribution
    return @distribution if defined?(@distribution)

    @distribution = @ngram_counts.to_h do |context, target_counts|
      total = target_counts.values.sum
      target_probabilities = target_counts.map do |token, count|
        TokenProbability[token, count / total.to_f]
      end
      [context, target_probabilities]
    end
  end
end

class LanguageModel
  DOCUMENT = "the cat sat on the mat"
  DEFAULT_SEQUENCE_LENGTH = 10
  N = 2
  def initialize
    @tokenizer = Tokenizer.new
    @probability_distribution = calculate_probability_distribution
  end

  def generate(sequence_length: DEFAULT_SEQUENCE_LENGTH)
    sequence = ["BOS"]
    Array.new(sequence_length) do
      next_token = generate_next_token(context: sequence.last)
      sequence << next_token
    end
    @tokenizer.detokenize(sequence)
  end

  protected

  def generate_next_token(context:)
    candidates = @probability_distribution[context]
    return Tokenizer::EOS if Array(candidates).empty?

    candidates.max_by(&:probability).token
  end

  def calculate_probability_distribution
    document = "BOS #{DOCUMENT} EOS"
    tokens = @tokenizer.tokenize(document)
    counts = NGramCounter.new(tokens: tokens, n: N).ngram_counts
    ProbabilityDistribution.new(ngram_counts: counts).distribution
  end
end
