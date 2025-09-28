
require "delegate"

class ProbabilityDistribution < DelegateClass(Array)
  require 'rational'
  require_relative "../lib/ngram"
  require_relative "../lib/ngram_probability"

  def initialize(tokens: [], n: 1)
    @ngrams = Array(tokens).each_cons(n).map { |n_tokens| NGram[n_tokens] }

    ngram_probabilities = calculate_probabilities_for_ngrams_in_samples

    super(ngram_probabilities)
  end

  protected

  def calculate_probabilities_for_ngrams_in_samples
    ngram_counts = @ngrams.tally
    total_ngrams_count = ngram_counts.values.sum
    ngram_counts.map do |ngram, count|
      probability = Rational(count, total_ngrams_count)
      NGramProbability[ngram, probability]
    end
  end
end
