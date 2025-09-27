class NextTokenGenerator
  require_relative "ngram"
  require_relative "ngram_probability"
  require_relative 'tokenizer'

  TERMINATING_NGRAM_PROBABILITY = NGramProbability.new(
    ngram: NGram[Tokenizer.eos_tokens],
    probability: 1.0
  )


  def initialize(probability_distributions:, context:)
    @probability_distributions = probability_distributions
    @context = context
  end


  def generate
    matching = @probability_distributions
           .filter { |ngram_prob| ngram_prob.ngram.start_with?(@context) }
    highest_probability_ngram  = matching
           .max_by(&:probability)

    highest_probability_ngram ||= TERMINATING_NGRAM_PROBABILITY
    highest_probability_ngram.ngram.last_token
  end
end
