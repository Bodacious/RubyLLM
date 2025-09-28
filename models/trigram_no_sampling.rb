# frozen_string_literal: true

require 'bundler'

Bundler.setup(:development)

class TrigramNoSampling
  BOS = '[BOS]'
  EOS = '[EOS]'
  CORPUS = "#{BOS} the cat sat on the mat #{EOS}".split

  MAX_TOKENS = 10
  NGRAM_SIZE = 3

  NGram = Data.define(:tokens) do
    def start_with?(lookback_context)
      tokens.first(lookback_context.size) == lookback_context
    end

    def last_token
      tokens.last
    end
  end
  NGramProbability = Data.define(:ngram, :probability)

  def initialize
    @probability_distributions = calculate_probability_distributions
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
    output.compact.join(' ')
  end

  protected

  def generate_next_token(context)
    lookback_context = context.last(NGRAM_SIZE - 1)
    ngrams_sorted_by_probability = @probability_distributions
                                   .filter { |ngram_prob| ngram_prob.ngram.start_with?(lookback_context) }
                                   # Sort by probability DESC, precedence ASC
                                   .sort_by
                                   .with_index { |ngram_prob, i| [ngram_prob.probability, i] }
    highest_probability_ngram = ngrams_sorted_by_probability.first

    return nil if highest_probability_ngram.nil?

    highest_probability_ngram.ngram.last_token
  end

  def calculate_probability_distributions
    ngrams = CORPUS.each_cons(NGRAM_SIZE).collect { |tokens| NGram[tokens] }
    ngram_counts = ngrams.tally
    total_ngrams_count = ngram_counts.values.sum
    ngram_counts.map do |ngram, count|
      probability = Rational(count, total_ngrams_count)
      NGramProbability[ngram, probability.to_f]
    end
  end
end
