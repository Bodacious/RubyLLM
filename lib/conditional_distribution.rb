# frozen_string_literal: true

class ConditionalDistribution
  def initialize(context:, token_probs:)
    @context = context
    @token_probs = token_probs
  end

  attr_reader :context

  def next_token
    return nil if @token_probs.empty?

    @token_probs.max_by { |_, prob| prob }.first.last_token
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
