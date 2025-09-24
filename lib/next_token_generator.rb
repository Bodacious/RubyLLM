class NextTokenGenerator
  require_relative "ngram"
  require_relative "ngram_probability"

  def initialize(probability_distributions:, context:)
    @probability_distributions = probability_distributions
    @context = context
  end


  def generate
    highest_probability_ngram  = @probability_distributions
                                      .filter { |ngram_prob| ngram_prob.ngram.start_with?(@context) }
                                      .max_by(&:probability)

    return nil unless highest_probability_ngram
    highest_probability_ngram.ngram.last_token
  end
end
