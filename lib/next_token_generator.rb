class NextTokenGenerator
  require_relative "ngram"
  require_relative "ngram_probability"
  require_relative 'tokenizer'

  def initialize(probability_distributions:)
    @probability_distributions = probability_distributions.sort_by! { |pd| -pd.probability }
  end

  def generate_next(context:)
    highest_probability_ngram = @probability_distributions
           .find { |ngram_prob| ngram_prob.ngram.start_with?(context) }

    return nil if highest_probability_ngram.nil?

    highest_probability_ngram.ngram.last_token
  end
end
