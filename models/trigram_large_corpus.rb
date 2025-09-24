# frozen_string_literal: true

require 'bundler'
require_relative "../lib/probability_distribution"
require_relative "../lib/corpus"
require_relative "../lib/next_token_generator"

Bundler.setup(:development)

class TrigramLargeCorpus
  BOS = "[BOS]"
  EOS = "[EOS]"
  MAX_TOKENS = 10
  NGRAM_SIZE = 3

  def initialize
    corpus = Corpus.new(name: :frankenstein)
    @probability_distributions = ProbabilityDistribution.new(samples: corpus.samples, n: 3)
  end

  def generate(prompt: nil, sequence_length: MAX_TOKENS)
    output = [BOS, *prompt.to_s.downcase.chars]

    until output.last.nil?
      break if output.last == EOS
      break if output.length >= sequence_length
      context = output.last(NGRAM_SIZE)
      next_token = generate_next_token(context)
      output << next_token
    end
    output.delete(BOS)
    output.delete(EOS)
    output.compact.join
  end

  protected

  def generate_next_token(context)
    lookback_context = context.last(NGRAM_SIZE - 1)
    NextTokenGenerator.new(context: lookback_context,
                           probability_distributions: @probability_distributions).generate
  end
end
