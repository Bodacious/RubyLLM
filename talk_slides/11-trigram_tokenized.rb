# frozen_string_literal: true

class Document
  attr_reader :samples

  def initialize
    @samples = [
      "The cat sat on the mat"
    ]
  end
end

class Tokenizer
  require "pycall/import"
  include PyCall::Import

  BOS = "!!!"
  EOS = " ``"

  def initialize(encoding: "cl100k_base")
    pyimport :tiktoken
    @encoder = tiktoken.get_encoding(encoding)
  end

  def bos_token = @encoder.encode(BOS).first
  def eos_token = @encoder.encode(EOS).first

  def tokenize(*samples)
    text = samples.map { |s| "#{BOS} #{s.downcase.strip}#{EOS}" }.join
    Array(@encoder.encode(text))
  end

  # Decode token IDs back into text
  def detokenize(tokens)
    tokens.delete(bos_token)
    tokens.delete(eos_token)
    @encoder.decode(tokens)
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
    tokens.each_cons(@n) do |ngram|
      context = ngram[0..-2]  # first n-1 tokens
      target  = ngram[-1]     # last token
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
  DEFAULT_SEQUENCE_LENGTH = 10
  N = 3
  def initialize
    @tokenizer = Tokenizer.new
    @probability_distribution = calculate_probability_distribution
  end

  def generate(prompt: ARGV[0], sequence_length: DEFAULT_SEQUENCE_LENGTH)
    sequence = @tokenizer.tokenize(prompt)[0..-2]
    until sequence.last == @tokenizer.eos_token
      break if sequence.length >= sequence_length

      next_token = generate_next_token(context: sequence.last(N - 1))
      sequence.push next_token
    end
    @tokenizer.detokenize(sequence)
  end

  protected

  def generate_next_token(context:)
    candidates = @probability_distribution[context]
    return @tokenizer.eos_token if candidates.nil?

    candidates.max_by(&:probability).token
  end

  def calculate_probability_distribution
    tokens = @tokenizer.tokenize(*Document.new.samples)
    counts = NGramCounter.new(tokens: tokens, n: N).ngram_counts
    ProbabilityDistribution.new(ngram_counts: counts).distribution
  end
end
