# frozen_string_literal: true

require 'delegate'

# frozen_string_literal: true

# Represents an n-gram language model trained on a corpus of token sequences.
#
# An NGramModel maps each observed (n-1)-token context window to a
# ConditionalDistribution of possible next tokens and their associated
# probabilities. Together, these distributions define the conditional
# probability space:
#
#   P(wₙ | w₁ … wₙ₋₁)
#
# For example, given the training samples:
#   "see the cat"
#   "see the dog"
#   "see the cat"
#
# The model will learn:
#   ["see", "the"] => { "cat" => 2/3, "dog" => 1/3 }
#
# This object is the core representation of the language model itself:
# it stores the conditional probability table and exposes methods to
# retrieve distributions for specific contexts.
class NGramModel < DelegateClass(Hash)
  def self.build(ngrams: [])
    # All unique NGrams, grouped by their context
    # { ['token_a', 'token_b'] => [Ngram1, NGram2, NGram3] }
    contexts_with_ngrams = ngrams.group_by(&:context)
    distributions = {}
    contexts_with_ngrams.each do |(context, ngrams_for_context)|
      total = ngrams_for_context.size.to_f
      counts = ngrams_for_context.tally(&:next_token)
      counts.transform_values! { |c| c / total }
      distributions[context] = ConditionalDistribution.new(context: context,
                                                           token_probs: counts)
    end
    new(distributions)
  end
end
