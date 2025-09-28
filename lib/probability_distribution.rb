# frozen_string_literal: true

require_relative 'ngram'
require_relative 'ngram_probability'
require_relative 'conditional_distribution'

class ProbabilityDistribution
  def initialize(tokens:, n: 3)
    @n = n
    @vocab = tokens.uniq
    @distributions = build_distributions(tokens)
  end

  def distribution_for(context)
    @distributions[context] || ConditionalDistribution.new(context: context, token_probs: {})
  end

  private

  def build_distributions(tokens)
    # A list of all unique NGrams in the training documents
    ngrams = tokens.each_cons(@n).map { |arr| NGram[arr] }
    # All unique NGrams, grouped by their context
    # { ['token_a', 'token_b'] => [Ngram1, NGram2, NGram3] }
    grouped = ngrams.group_by(&:context)
    NGramModel.build(contexts_with_ngrams: grouped)
  end
end
