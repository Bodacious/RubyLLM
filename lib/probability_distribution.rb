
require "delegate"
class ProbabilityDistribution < DelegateClass(Array)
  require 'rational'
  require_relative "../lib/ngram"
  require_relative "../lib/ngram_probability"

  BOS = "[BOS]"
  EOS = "[EOS]"

  def initialize(samples: [], n: 1)
    @ngrams = Array(samples).flat_map do |sample|
      sample_chars = sample.chars
      sample_chars.unshift(BOS)
      sample_chars.push(EOS)
      sample_chars.each_cons(n).map { |tokens| NGram[tokens] }
    end
    ngram_probabilities = calculate_probabilities_for_ngrams_in_samples

    super(ngram_probabilities)
  end

  protected

  def calculate_probabilities_for_ngrams_in_samples
    ngram_counts = @ngrams.tally
    total_ngrams_count = ngram_counts.values.sum
    ngram_counts.map do |ngram, count|
      probability = Rational(count, total_ngrams_count)
      NGramProbability[ngram, probability.to_f]
    end
  end
end
