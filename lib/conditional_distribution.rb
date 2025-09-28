# frozen_string_literal: true

class ConditionalDistribution
  def initialize(context:, token_probs:)
    @context = context
    @token_probs = token_probs # { token => Float (probability) }
  end

  attr_reader :context

  def next_token
    r = rand
    cumulative = 0.0
    @token_probs.each do |ngram, prob|
      cumulative += prob
      return ngram.last_token if r <= cumulative
    end
    @token_probs.keys.last
  end

  def [](token)
    @token_probs[token]
  end

  def tokens
    @token_probs.keys
  end

  def probabilities
    @token_probs.values
  end
end
