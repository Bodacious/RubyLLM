# frozen_string_literal: true

require_relative "ngram"
require_relative "ngram_probability"
require_relative "conditional_distribution"

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
    ngrams = tokens.each_cons(@n).map { |arr| NGram[arr] }
    grouped = ngrams.group_by(&:context)

    grouped.transform_values do |ngrams_for_context|
      total = ngrams_for_context.size.to_f
      counts = ngrams_for_context.tally { |ngram| ngram.next_token }
      token_probs = counts.transform_values { |c| c / total }

      ConditionalDistribution.new(context: ngrams_for_context.first.context, token_probs: token_probs)
    end
  end
end
