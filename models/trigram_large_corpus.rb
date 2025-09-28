# frozen_string_literal: true

require 'bundler'
require_relative '../lib/probability_distribution'
require_relative '../lib/corpus'
require_relative '../lib/next_token_generator'
require_relative '../lib/word_tokenizer'
require_relative '../lib/bpe_tokenizer'

Bundler.setup(:development)

class TrigramLargeCorpus
  MAX_TOKENS = 10_000
  NGRAM_SIZE = 3

  def initialize
    corpus = Corpus.new(name: :frankenstein)
    @tokenizer = BPETokenizer.new
    probability_distribution = ProbabilityDistribution.new(
      tokens: corpus.samples.flat_map { |sample| @tokenizer.tokenize(sample) },
      n: NGRAM_SIZE
    )
    @next_token_generator = NextTokenGenerator.new(
      probability_distribution: probability_distribution
    )
  end

  def generate(prompt: nil, sequence_length: MAX_TOKENS)
    output = @tokenizer.tokenize("#{@tokenizer.bos} #{prompt.downcase}")
    eos_size = @tokenizer.eos_tokens.size
    until output.last.nil?
      break if output.last(eos_size) == @tokenizer.eos_tokens
      break if output.length >= sequence_length

      context = output.last(NGRAM_SIZE)
      next_token = generate_next_token(context)
      output << next_token
    end
    string = @tokenizer.detokenize(output.compact)
    string.delete!(@tokenizer.bos)
    string.delete!(@tokenizer.eos)
    string.strip
  end

  protected

  def generate_next_token(context)
    lookback_context = context.last(NGRAM_SIZE - 1)
    @next_token_generator.generate_next(context: lookback_context)
  end
end
