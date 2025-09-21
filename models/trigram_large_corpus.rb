# frozen_string_literal: true

require 'bundler'
require_relative "../lib/probability_distribution"
require_relative "../lib/corpus"
Bundler.setup(:development)

class TrigramLargeCorpus
  BOS = "[BOS]"
  EOS = "[EOS]"
  MAX_TOKENS = 10
  NGRAM_SIZE = 3



  def initialize
    corpus = Corpus.new(name: :simple)
    @probability_distributions = ProbabilityDistribution.new(samples: corpus.samples, n: 3)
  end

  def generate(prompt: nil, sequence_length: MAX_TOKENS)
    output = [BOS, prompt.to_s.downcase]

    until output.last.nil?
      break if output.last == EOS
      break if output.length >= sequence_length
      context = output.last(NGRAM_SIZE)
      next_token = generate_next_token(context)
      output << next_token
    end
    output.delete(BOS)
    output.delete(EOS)
    output.compact.join(" ")
  end

  protected

  def generate_next_token(context)
    lookback_context = context.last(NGRAM_SIZE - 1)
    ngrams_sorted_by_probability  = @probability_distributions
                                       .filter { |ngram_prob| ngram_prob.ngram.start_with?(lookback_context) }
                                       # Sort by probability DESC, precedence ASC
                                       .sort_by
                                       .with_index{ |ngram_prob, i| [ngram_prob.probability, i] }
    highest_probability_ngram = ngrams_sorted_by_probability.first

    return nil if highest_probability_ngram.nil?
    highest_probability_ngram.ngram.last_token
  end
end
