# frozen_string_literal: true

require 'delegate'
class NGramModel < DelegateClass(Hash)
  def self.build(contexts_with_ngrams: [])
    table_data = contexts_with_ngrams.each_with_object({}) do |(context, ngrams_for_context), distributions|
      total = ngrams_for_context.size
      counts = ngrams_for_context.tally(&:next_token)
      token_probs = counts.transform_values { |c| Rational(c, total) }
      distributions[context] = ConditionalDistribution.new(context: context,
                                                           token_probs: token_probs)
    end
    new(table_data)
  end
end
