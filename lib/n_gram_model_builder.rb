# frozen_string_literal: true

require_relative 'ngram'
require_relative 'ngram_model'
require_relative 'conditional_distribution'

class NGramModelBuilder
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
    NGramModel.build(ngrams: ngrams)
  end
end
