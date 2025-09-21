class NextTokenGenerator
  require_relative "ngram"
  require_relative "ngram_probability"

  EOS = "[EOS]"

  def initialize(probability_distributions:, context:)
    @probability_distributions = probability_distributions
    @context = context
  end

  TERMINATING_NGRAM_PROBABILITY = NGramProbability.new(ngram: NGram[[EOS]], probability: 1.0)
  def generate
    ngrams_sorted_by_probability  = @probability_distributions
                                      .filter { |ngram_prob| ngram_prob.ngram.start_with?(@context) }
                                      # Sort by probability DESC, precedence ASC
                                      .sort_by
                                      .with_index{ |ngram_prob, i| [ngram_prob.probability] }
    highest_probability_ngram = ngrams_sorted_by_probability.first || TERMINATING_NGRAM_PROBABILITY

    highest_probability_ngram.ngram.last_token
  end
end
