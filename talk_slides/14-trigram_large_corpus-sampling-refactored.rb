# frozen_string_literal: true

class Document
  IGNORED_PUNCTUATION_REGEXP = /(\[|\]"|“|”|’|\r?\n)/
  # Matches tokens in text:
  # - 1st capture: complete words; allows internal apostrophes or dashes (don’t, mother-in-law)
  # - 2nd capture: terminal punctuation returned as its own token (full stop or exclamation)
  # - 3rd capture: commas and semicolons as their own tokens
  # - 4th capture: spaces
  # Notes:
  # - Quotes (straight/curly) and square brackets are ignored (not matched)
  # - Underscores are ignored (not part of words)
  WORD_REGEX = /
    (?:
      [[:alnum:]]+
      (?:['-][[:alnum:]]+)*
    )
    |
    (?:[.!])
    |
    (?:[,;])
    |
    (?:\s+)
  /x

  attr_reader :samples

  def initialize(name = "simple_text")
    @samples = File.readlines("documents/#{name}.txt").lazy.map do |line|
      line.gsub!(IGNORED_PUNCTUATION_REGEXP, "")
      line.strip!
      line.scan(WORD_REGEX).join
    end.reject(&:empty?)
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
    @ngram_counts = Hash.new { |h, k| h[k] = Hash.new(0) }
    count_ngrams(tokens)
  end

  protected

  def count_ngrams(tokens)
    tokens.each_cons(@n) do |ngram|
      context = ngram[0..-2]
      target  = ngram[-1]
      @ngram_counts[context][target] += 1
    end
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

class TokenGenerator
  def initialize(eos_token:, probability_distribution: {}, temperature: 1.0)
    @eos_token = eos_token
    @probability_distribution = probability_distribution
    @temperature = temperature
  end

  def next_token(context)
    candidates = @probability_distribution[context]
    return @eos_token if Array(candidates).empty?

    sample(candidates)
  end

  private

  def sample(candidates)
    # Apply temperature scaling
    adjusted = candidates.to_h do |c|
      scaled = Math.exp(Math.log(c.probability) / @temperature)
      [c.token, scaled]
    end

    # Normalize to probabilities that sum to 1
    total = adjusted.values.sum
    normalized = adjusted.transform_values { |v| v / total }

    # Weighted random draw
    pick = rand
    cumulative = 0.0
    normalized.each do |token, prob|
      cumulative += prob
      return token if pick <= cumulative
    end

    candidates.last.token
  end
end

class LanguageModel
  DEFAULT_SEQUENCE_LENGTH = (ARGV[1] || 10).to_i
  TEMPERATURE = (ARGV[2] || 1.0).to_f
  N = 3

  def initialize
    @document = Document.new("frankenstein_text")
    @tokenizer = Tokenizer.new
    @probability_distribution = calculate_probability_distribution
    @generator = TokenGenerator.new(
      probability_distribution: @probability_distribution,
      eos_token: @tokenizer.eos_token,
      temperature: TEMPERATURE
    )
  end

  def generate(prompt: ARGV[0], sequence_length: DEFAULT_SEQUENCE_LENGTH)
    sequence = @tokenizer.tokenize(prompt)[0..-2]
    until sequence.last == @tokenizer.eos_token
      break if sequence.length >= sequence_length

      next_token = @generator.next_token(sequence.last(N - 1))
      sequence.push(next_token)
    end
    @tokenizer.detokenize(sequence)
  end

  private

  def calculate_probability_distribution
    tokens = @tokenizer.tokenize(*@document.samples)
    counts = NGramCounter.new(tokens: tokens, n: N).ngram_counts
    ProbabilityDistribution.new(ngram_counts: counts).distribution
  end
end
