# frozen_string_literal: true

require 'bundler'
require_relative "../lib/probability_distribution"
require_relative "../lib/corpus"
require_relative "../lib/next_token_generator"
require_relative "../lib/tiktoken"

Bundler.setup(:development)

class TrigramLargeCorpus
  MAX_TOKENS = 200
  NGRAM_SIZE = 5

  def initialize
    corpus = Corpus.new(name: :frankenstein)
    @tokenizer = Tokenizer.new
    @probability_distributions = ProbabilityDistribution.new(
      tokens: corpus.samples.flat_map { |sample| @tokenizer.tokenize(sample) },
      n: NGRAM_SIZE
    )
  end

  def generate(prompt: nil, sequence_length: MAX_TOKENS)
    output = @tokenizer.tokenize("#{Tokenizer::BOS} #{prompt.downcase}")
    eos_size = Tokenizer::eos_tokens.size
    until output.last.nil?
      break if output.last(eos_size) == Tokenizer::eos_tokens
      break if output.length >= sequence_length
      context = output.last(NGRAM_SIZE)
      next_token = generate_next_token(context)
      output << next_token
    end
    string = @tokenizer.detokenize(output.compact)
    string.delete!(Tokenizer::BOS)
    string.delete!(Tokenizer::EOS)
    string.strip
  end

  protected

  def generate_next_token(context)
    lookback_context = context.last(NGRAM_SIZE - 1)
    NextTokenGenerator.new(
      context: lookback_context,
      probability_distributions: @probability_distributions
    ).generate
  end
end
